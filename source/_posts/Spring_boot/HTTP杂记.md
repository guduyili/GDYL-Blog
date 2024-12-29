---
title: HTTP杂记
date: 2024-11-26
updated: 2024-11-26
categories: 
- Spring-boot
tag:
- learning
---
<!-- toc -->

[toc]



## HTTP协议-请求数据格式

- 请求行：请求数据第一行（请求方式，资源路径，协议）

- 请求头：第二行开始，格式key: value

- 请求体：POST请求，存放请求参数（与请求头之间隔了一个空行）

  

  **请求方式-GET**： 请求参数在请求行中，没有请求体，如：/brand/findAll?name=OPPO&status=1。

  GET请求大小在浏览器中是有限制的

  **请求方式-POST**： 请求参数在请求体中，POST请求大小是没有限制的

------

## HTTP协议-请求数据获取

```java
@RestController
public class RequestController {

    @RequestMapping("/request")
    public String request(HttpServletRequest request){
        //1. 获取请求方式
        String method = request.getMethod();//GET
        System.out.println("请求方式：" + method);


        //2. 获取请求url uri地址
        String url = request.getRequestURL().toString();//http://localhost:8080/request
        System.out.println("请求url地址：" + url);

        String uri = request.getRequestURI();//  /request
        System.out.println("请求uri地址：" + uri);


        //3. 获取请求协议
        String protocol = request.getProtocol();// HTTP/1.1
        System.out.println("请求协议：" + protocol);

        //4. 获取请求参数 - name
        String name = request.getParameter("name");
        String age = request.getParameter("age");
        System.out.println("name: " + name + ", age: " + age);

        //5. 获取请求头 - Accept
        String accept = request.getHeader("Accept");
        System.out.println("Accept: " + accept);
        return "ok";
    }
}

请求方式：GET
请求url地址：http://localhost:8080/request
请求uri地址：/request
请求协议：HTTP/1.1
name: 姜维, age: 11
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
```



------



## HTTP协议-相应数据格式

|      |                                                              |
| :--: | :----------------------------------------------------------: |
| 1xx  | 响应中-临时状态码，表示请求已经接收，告诉客户端应该继续请求或者如果它已经完成则忽略它 |
| 2xx  |           成功-表示请求已经被成功接收，处理已完成            |
| 3xx  | 重定向-重定向到其他地方，让客户端再发起一次请求以完成整个处理 |
| 4xx  | 客户端错误-处理发生错误，责任在客户端。如：请求了不存在的资源，客户端未被授权，禁止访问等 |
| 5xx  | 服务器错误-处理发生错误，责任在服务器。如：程序抛出异常等。  |

------



|                  |                                                          |
| ---------------- | :------------------------------------------------------: |
| Content-Type     |  表示该响应内容的类型，例如text/html，application/json   |
| Content-Length   |              表示该响应内容的长度（等字节）              |
| Content-Encoding |               表示该响应压缩算法，例如gzip               |
| Cache-Control    | 指示客户端如何缓存，例如max-age=300表示可以最多缓存300秒 |
| Set-Cookie       |          告诉浏览器为当前页面所在的域设置cookie          |

------



## HTTP协议-响应数据设置

```java
@RestController
public class ResponseController {

    /**
     * 方式一： HttpServletResponse 设置响应数据
     * @param response
     * @throws IOException
     */
    @RequestMapping("/response")
    public  void response(HttpServletResponse response) throws IOException {
        //1. 设置响应状态码
        response.setStatus(401);
        //2。 设置响应头
        response.setHeader("name","JW");
        //3. 设置响应体
        response.getWriter().write("<h1>hello JW</h1>");
    }

    @RequestMapping("/response2")
    public ResponseEntity<String>response2(){
        return  ResponseEntity
                .status(401)//设置响应状态码
                .header("name","GFjw")//响应头
                .body("<h1>hello GFjw</h1>");//响应体
    }
}
```

------

## 三层架构

- controller：控制层，接受前端发送的请求，对请求进行处理，并响应数据
- service： 业务逻辑层，处理具体的业务逻辑
- dao： 数据访问层（Data Access Object）(持久层)，包括数据的增，删，查，改

------



## 分层耦合

- 耦合： 衡量软件中各个层/各个模块的依赖关联程度
- 内聚： 软件中各个功能模块内部的功能联系



**控制反转**：Inversion Of Control 简称为IOC。对象的创建控制权由程序自身转移到外部（容器），这种思想称为控制反转



**依赖注入**： Dependency Injection 简称DI。容器为应用程序提供运行时，所依赖的资源，称之为依赖注入。



**Bean对象**： IOC容器中创建，管理的对象称之为Bean。



1. 如何将一个类交给IOC容器管理？ 
   - @Component（注意：是加在实现类impl上，而不是加在接口上）
2. 如何从IOC容器中找到该类型的bean，然后完成依赖注入？
   - @Autowired

​	

## IOC详解

| 注解        | 说明                 | 位置                                            |
| ----------- | -------------------- | ----------------------------------------------- |
| @Component  | 声明bean的基础注解   | 不属于以下三类，用此注解                        |
| @Controller | @Component的衍生注解 | 标注在控制层上                                  |
| @Service    | @Component的衍生注解 | 标注在业务层上                                  |
| @Repository | @Component的衍生注解 | 标注在数据访问层上（由于与mybatis整合，用的少） |

## DI详解

1.依赖注入的注解

- @Autowired ： 默认按照类型自动装配
- 如果同类型的bean存在多个：
  - @Primary
  - @Autowired + @Qualifier
  - @Resource

2.@Resource 与 @Autowired区别

- @Autowired是Spring框架提供的注解，而@Resource是JavaEE规范提供的
- @Autowired默认是按照类型注入，而@Resource默认是按照名称注入

## Cookie

## 响应头

- Set-Cookie

```java
    @GetMapping("/c1")
    public Result cookie1(HttpServletResponse response){
        response.addCookie(new Cookie("login_name","guduyili"));//设置Cookie/响应Cookie
        return Result.success();
    }
```



### 请求头

- Cookie

```java
    @GetMapping("/c2")
    public Result cookie12(HttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        for(Cookie cookie : cookies){
            if(cookie.getName().equals("login_name")){
                System.out.println("login_name: " + cookie.getValue());//输出name为login_username的cookie
            }
        }
        return Result.success();
    }
```

- 优点：HTTP协议中支持的技术
- 缺点：
  - 移动端App无法使用Cookie
  - 不安全，用户可以自己禁用Cookie
  - Cookie不能跨域

## Session

- Session的底层是基于Cookie的(Set-Cookie,Cookie)

```java
    @GetMapping("/s1")
    public Result session1(HttpSession session){
        log.info("HttpSession-s1: {}",session.hashCode());

        session.setAttribute("loginUser","伯约");
        return Result.success();
    }

    @GetMapping("/s2")
    public Result session2(HttpSession session){
        log.info("HttpSession-s2: {}",session.hashCode());

        Object loginUser = session.getAttribute("loginUser");
        log.info("loginUser:{}",loginUser);
        return Result.success();
    }
}
```

- 优点：存储在服务端，安全
- 缺点：
  - 服务器集群环境下无法直接使用Session
  - Cookie的缺点

## 令牌

### JWT令牌

- JSON Web Token（https://jwt.io/）
- 组成：
  - 第一部分：Header(头),记录令牌类型，签名算法等，
  - 第二部分：Payload（有效载荷），携带一些自定义信息，默认信息等
  - 第三部分：Signature（签名），防止Token被篡改，确保安全性，将header，payload融入，并加入指定密钥，通过指定签名算法计算而来

## 过滤器（Filter）

- Filter过滤器，是JavaWeb三大组件（）之一。
- 过滤器可以把对资源的请求**拦截**下来，从而实现一些特殊功能
- 过滤器一般完成一些**通用**的操作，比如：登录校验，统一编码处理，敏感字符处理等

```java
package com.jw.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;

/***
 *@title DemoFilter
 *@description <TODO description class purpose>
 *@author lzy33
 *@version 1.0.0
 *@create 29/12/2024 下午 9:38
 **/
@Slf4j
@WebFilter(urlPatterns = "/*")//拦截所有请求
public class DemoFilter implements Filter {
    //初始化方法，web服务器启动时执行，只执行一次
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        /*Filter.super.init(filterConfig);*/
        log.info("init 初始化方法...");
    }

    //拦截到请求之后，会执行多次
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        log.info("拦截到请求...");
        //放行
        filterChain.doFilter(servletRequest,servletResponse);
    }

    //销毁方法，web服务器关闭的时候执行，只执行一次
    @Override
    public void destroy() {
        // Filter.super.destroy();
        log.info("destroy 销毁方法...");
    }
}


@WebFilter(urlPatterns = "/*")//拦截所有请求
@ServletComponentScan//开启SpringBoot对Servlet组件的支持
放行 ：chain.doFilter(request,response)
```

