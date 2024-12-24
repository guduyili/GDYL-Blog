---
title: Springboot
date: 2024-11-28
updated: 2024-11-28
categories: 
- Spring-boot
tag:
- learning
---
<!-- toc -->

[toc]



# **一个Springboot的初始项目**

项目的src\main结构

```
PS C:\Intellij\Pro\Test1\Pojo_Sec\src\main> tree
卷 系统 的文件夹 PATH 列表
卷序列号为 E4AC-4A0F
C:.
├─java
│  └─gdylt
│      └─com
│          └─pojo_sec
│              ├─Controller
│              ├─dao
│              │  └─impl
│              ├─pojo
│              └─service
│                  └─impl
└─resources
    ├─static
    │  └─js
    └─templates
```

### index.html

```html
<!--index.html-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User List</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
<h1>User List</h1>
<table id="userTable">
    <thead>
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Password</th>
        <th>Name</th>
        <th>Age</th>
        <th>Update Time</th>
    </tr>
    </thead>
    <tbody>
    <!-- User data will be inserted here -->
    </tbody>
</table>

<script src="script.js"></script>
</body>
</html>
```

### script.js

```js
<!--script.js-->
document.addEventListener("DOMContentLoaded", function() {
    fetch('/list')
        .then(response => response.json())
        .then(data => {
            const userTableBody = document.querySelector('#userTable tbody');
            data.forEach(user => {
                const row = document.createElement('tr');

                const idCell = document.createElement('td');
                idCell.textContent = user.id;
                row.appendChild(idCell);

                const usernameCell = document.createElement('td');
                usernameCell.textContent = user.username;
                row.appendChild(usernameCell);

                const passwordCell = document.createElement('td');
                passwordCell.textContent = user.password;
                row.appendChild(passwordCell);

                const nameCell = document.createElement('td');
                nameCell.textContent = user.name;
                row.appendChild(nameCell);

                const ageCell = document.createElement('td');
                ageCell.textContent = user.age;
                row.appendChild(ageCell);

                const updateTimeCell = document.createElement('td');
                updateTimeCell.textContent = user.updateTime;
                row.appendChild(updateTimeCell);

                userTableBody.appendChild(row);
            });
        })
        .catch(error => console.error('Error fetching user data:', error));
});
```

### UserController

```java
//UserController.java
@RestController
public class UserController {


    @RequestMapping("/list")
    public List<User> list() throws Exception {
        //1. 加载并读取user.txt文件，获取用户数据
        InputStream in = this.getClass().getClassLoader().getResourceAsStream("user.txt");
        ArrayList<String> lines = IoUtil.readLines(in, StandardCharsets.UTF_8, new ArrayList<>());

        //2. 解析用户信息，封装为User对象 -> list集合
        List<User> userList = lines.stream().map(line -> {
            String[] parts = line.split(",");
            Integer id = Integer.parseInt(parts[0]);
            String username = parts[1];
            String password = parts[2];
            String name = parts[3];
            Integer age = Integer.parseInt(parts[4]);
            LocalDateTime updateTime = LocalDateTime.parse(parts[5], DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            return new User(id, username, password, name, age, updateTime);
        }).toList();
        //3. 返回数据（json）
        return userList;
    }
}    
```

```java
//User
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private Integer id;
    private String username;
    private String password;
    private String name;
    private Integer age;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
```

------

## IOC DI

项目结构

通过controller service dao重构

```
PS C:\Intellij\Pro\Test1\Pojo_Sec\src\main> tree /F
卷 系统 的文件夹 PATH 列表
卷序列号为 E4AC-4A0F
C:.
├─java
│  └─gdylt
│      └─com
│          └─pojo_sec
│              │  PojoSecApplication.java
│              │
│              ├─Controller
│              │      UserController.java
│              │
│              ├─dao
│              │  │  UserDao.java
│              │  │
│              │  └─impl
│              │          UserDaoImpl.java
│              │
│              ├─pojo
│              │      User.java
│              │
│              └─service
│                  │  UserService.java
│                  │
│                  └─impl
│                          UserServiceImpl.java
│
└─resources
    │  application.properties
    │  user.txt
    │
    ├─static
    │  │  index.html
    │  │  script.js
    │  │
    │  └─js
    └─templates
```

### UserController

```java
@RestController
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/list")
    public List<User> list() throws Exception{
        //1. 调用service，获取数据
        List<User>userList = userService.findAll();//


        //2. 返回数据（json）
        return userList;
    }
}

```



### Dao

#### UserDao

```java
public interface UserDao {

    /**
     * 加载用户数据
     * @return
     */
    public List<String>findAll();
}
```

#### UserDaoImpl

```java
@Component //将当前类交给IOC容器管理
public class UserDaoImpl implements UserDao {

    @Override
    public List<String> findAll() {
        //1. 加载并读取user.txt文件，获取用户数据
        InputStream in = this.getClass().getClassLoader().getResourceAsStream("user.txt");
        ArrayList<String> lines = IoUtil.readLines(in, StandardCharsets.UTF_8,new ArrayList<>());
        return lines;
    }
}
```

### Sevice

#### UserService

```java
public interface UserService {

    /**
     * 查询所有用户信息
     * @return
     */
        public List<User> findAll();
}
```

#### UserServiceImpl

```java
@Component
public class UserServiceImpl implements UserService {
    @Autowired //应用程序运行时，会自动的查询该类型的bean对象，并赋值给该成员变量
    private UserDao userDao;
    @Override
    public List<User> findAll() {
        //1.调用dao，获取数据
        List<String>lines = userDao.findAll();

        //2. 解析用户信息，封装为User对象 -> list集合
        List<User> userList = lines.stream().map(line ->{
            String[] parts = line.split(",");
            Integer id = Integer.parseInt(parts[0]);
            String username = parts[1];
            String password = parts[2];
            String name = parts[3];
            Integer age = Integer.parseInt(parts[4]);
            LocalDateTime updateTime = LocalDateTime.parse(parts[5], DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            return new User(id,username,password,name,age,updateTime);
        }).toList();
        return userList;
    }
}
```

# Meituan

##  字段名与实体类属性名不一致

```java
/**
     * 方式一：手动映射
     * @return
     */
    @Results({
            @Result(column = "create_time", property = "createTime"),
            @Result(column = "update_time", property = "updateTime"),
    })

    /**
     * 方式二：在SQL语句中，对不一样的列名起别名，别名和实体类属性名一样
     */
    @Select("select id,name,create_time createTime,update_time updateTime from meituan order by update_time desc")

    /**
     * 方式三：开启驼峰命名
     * @return
     */
        map-underscore-to-camel-case: true
```

## 删除

```java
   /**
     * 方式一：HttpServletRequest 获取请求参数
     * @param request
     * @return
     */
    @DeleteMapping("/depts")
    public Result delete(HttpServletRequest request){
        String idStr = request.getParameter("id");
        int id = Integer.parseInt(idStr);
        System.out.println("根据ID删除部门" + id);
        return Result.success();
    }


    /**
     * 方式二：@RequestParam
     * 注意事项：一旦声明了@RequestParam 该参数在请求时必须传递 如果不船体将会报错 （默认required为true）
     * @param deptId
     * @return
     */
    @DeleteMapping("/depts")
    public Result delete(@RequestParam("id") Integer deptId){
            System.out.println("根据ID删除部门" + deptId);
            return Result.success();
    }

    /**
     * 方式三：省略@RequestParam（前端传递的请求参数名与服务端方法形参名一致）[推荐]
     */
    @DeleteMapping("/depts")
    public Result delete(Integer id){
        System.out.println("根据ID删除部门" + id);
        meituanService.deleteById(id);
        return Result.success();
    }
```

## 配置文件详解

- 配置文件名：logback.xml

- 该配置文件是对Logback日志框架输出的日志进行控制的，可以来配置输出的格式，位置及日志开关等

- 常用的两种输出日志的位置：控制台，系统文件

  ```xml
      <!--    控制台输出-->
      <appender name="STDOUT" class = "ch.qos.logback.core.ConsoleAppender">
          ......
  </appender>
  
      <!--系统文件输出-->
      <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
      ......
  </appender>
  
  ```

- 开启日志（ALL），关闭日志（OFF）

  ```xml
      <root level="off">
          <appender-ref ref="STDOUT" />
          <appender-ref ref="FILE" />
      </root>
  ```

## 日志级别

- 日志级别指的是日志信息的类型，日志都会分级别，常见的日志级别如下（级别由低到高）：

  | 日志级别 | 说明                                                         | 记录方式         |
  | -------- | ------------------------------------------------------------ | ---------------- |
  | trace    | 追踪，记录程序运行轨迹【使用很少】                           | log.trace("...") |
  | debug    | 调试，记录程序调试过程中的信息，实际应用中一般将其视为最低级别【使用很多】 | log.debug("...") |
  | info     | 记录一般信息，描述程序运行的关键事件，如：网络连接，io操作【使用很多】 | log.info("...")  |
  | warn     | 警告信息：记录潜在有害的情况【使用很多】                     | log.warn("...")  |
  | error    | 错误信息【使用很多】                                         | log.error("...") |

- 大于等于配置的日志级别的日志才会输出



# 多表关系

## 一对多

### 外键约束

- 可以在创建表时 或 表结构创建完成后，为字段添加外键约束

  ```mysql
  -- 创建表时限定
  create table 表名{
  		字段名 数据类型,
  		....
  		[constraint] [外键名称] foreign key (外键字段名) references 主表(字段名)
  };
  ```

  ```mysql
  -- 建完表后，添加外键
  alter table 表名 add constraint 外键名称 foreign key (外键字段名) references 主表 (字段名);
  ```

  

## 一对一

- 实现：在任意一方加入外键，关联另外一方的主键，并且设置外键为唯一的（UNIQUE）





## 多对多

- 实现：建立第三张中间表，中间表至少包含两个外键，分别关联两方主键

  

# 多表查询

- 连接查询
  - 内连接：相当于查询A，B交集部分数据
  - 外连接
    - 左外连接：查询**左表**所有数据（包括两张表交集部分数据）
    - 右外连接：查询**右表**所有数据（包括两张表交集部分数据）
- 子查询

​	

## 内连接

```mysql
-- 1.隐式内连接
select 字段列表 from 表1，表2 where 连接条件 ...;

-- 2.显式内连接
select 字段列表 from 表1 [inner] join 表2 on 连接条件 ...;
```

```mysql
-- 给表起别名，简化书写
select 字段列表 from 表1 [as] 别名1 , 表名2 [as] 别名2 where 条件 ...;
```

## 外连接

```mysql
-- 左外连接
select 字段列表 from 表1 left [outer] join 表2 on 连接条件;


-- 右外连接
select 字段列表 from 表1 right [outer] join 表2 on 连接条件;
```

## 子查询

- SQL语句中嵌套select语句，称为嵌套查询，又称为子查询

- select * from t1 where column1 = (select column2 from t2 ...);

- 子查询外部的语句可以是insert update delete select 的任何一个

- 分类：

  - 标量子查询：子查询返回的结果为单个值

  - 列子查询：子查询返回的结果为一列

  - 行子查询：子查询返回的结果为一行

  - 表子查询：子查询返回的结果为多行多列

    

# 动态SQL

- 随着用户的输入或外部条件而变化的SQL语句
- <if>: 判断条件是否成立
- <where>:根据查询条件，来生成where关键字，并会自动去除条件前面多余的and或or
