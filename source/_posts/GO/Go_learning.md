---
title: Go_learning
date: 2025-10-22
categories: 
- Go
tag:
- learning
---

<!-- toc -->

[TOC]

# Web Gee

## HTTP基础与上下文

![image-20251023165937459](./../../img/image-20251023165937459.png)

- **context**：封装`*http.Request`和`http.ResponseWriter`，以及解析动态路由，中间件。

  Context随着每一个请求的出现而产生，请求的结束而销毁，和当前i请求强相关的信息都应当由Context承载

- **router**：

​		![image-20251023210418956](./../../img/image-20251023210418956.png)

![image-20251023172424345](./../../img/image-20251023172424345.png)

​					![image-20251023172534028](./../../img/image-20251023172534028.png)

​					![image-20251023210405201](./../../img/image-20251023210405201.png)



## Trie树（前缀树）

![image-20251023211409726](./../../img/image-20251023211409726.png)

每一段可作为前缀树的一个节点，通过树结构查询，如果中间某一层的节点都不满足条件，那么就说明没有匹配到的路由，查询结束

动态路由实现一下两个功能。

- 参数匹配`:`.例如 `/p/:lang/doc`，可以匹配 `/p/c/doc` 和 `/p/go/doc`
- 通配`*`.例如 `/static/*filepath`，可以匹配`/static/fav.ico`，也可以匹配`/static/js/jQuery.js`，这种模式常用于静态服务器，能够递归地匹配子路径。

### 注册与匹配

开发服务时，注册路由规则，映射handler； 访问时，匹配路由规则

**插入**：递归查找每一层的节点，如果没有匹配到当前`part`节点，则新建一个，有一点需要注意，`/p/:lang/doc`只有在第三层节点，即`doc`节点，`pattern`才会设置为`/p/:lang/doc`。`p`和`:lang`节点的`pattern`属性皆为空。因此，当匹配结束时，我们可以使用`n.pattern == ""`来判断路由规则是否匹配成功。例如，`/p/python`虽能成功匹配到`:lang`，但`:lang`的`pattern`值为空，因此匹配失败。

**查询**：递归查询每一层的节点，退出规则为，匹配到`*`,匹配失败，或是匹配到了第`len(parts)`层节点

## 分组控制

路由分组

- 以`/post`开头的路由匿名可访问
- 以`/admin`开头的路由需要鉴权
- 以`/api`开头的路由是RESTful接口,可以对接第三方平台，需要第三方平台鉴权



## 中间件(middleware)

非业务的技术类组件

- 插入点在哪？使用框架的人并不关心底层逻辑的具体实现，如果插入点太底层，中间件逻辑就会非常复杂。如果插入点离用户太近，那和用户直接定义一组函数，每次在Handler中手工调用没有多大的优势了
- 中间件的输入是什么？中间件的输入，决定了扩展能力。暴露的参数太少，用户发挥空间有限

具体实现步骤：

路由组调用`Use`添加中间件到路由中

`engine.ServeHTTP` 先按照分组前缀把匹配的中间件依次塞进 [c.handlers](vscode-file://vscode-app/d:/Vs Code/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，`router.handle` 再把最终业务 `Handler` 追加到链尾，随后 [c.Next()](vscode-file://vscode-app/d:/Vs Code/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 驱动整条链，以“洋葱模型”方式按顺序执行前置逻辑、到内核处理器、再回溯执行后置逻辑

![image-20251029202805935](./../../img/image-20251029202805935.png)

# Cache

## LRU

![implement lru algorithm with golang](./../../img/lru.jpg)

- 蓝色的为字典(map),存储键和值的映射关系，这样根据某个键(key)查找对应的值(value)的复杂是`O(1)`,在字典中插入一条记录的复杂度也是`O(1)`
- 红色的双向链表(double linked list)实现的队列，将所有的值放到双向链表中，当访问到某个值时，将其移动到队尾的复杂度`O(1)`，在队尾新增一条记录以及删除一条巨鹿的复杂的均为`O(1)`

## 支持并发读写

抽象一个制度数据结构`ByteView`用来表示缓存值

```go
//Getter 是用户提供的数据源抽象：当缓存未命中时，框架通过该接口获取源数据
type Getter interface {
	Get(key string) ([]byte, error)
}

// 允许直接传入一个函数作为 Getter，便于测试和使用
type GetterFunc func(key string) ([]byte, error)

// Get 实现了 Getter 接口，使得任意符合签名的函数都能作为 Getter 使用
func (f GetterFunc) Get(key string) ([]byte, error) {
	return f(key)
}
```

- 定义接口Getter和回调函数`Get(key string) ([]byte, error)`，参数是key，返回值为`[]byte`
- 定义函数类型 GetterFunc，并实现 Getter 接口的 `Get` 方法。
- 函数类型实现某一个接口，称之为接口型函数，方便使用者在调用时既能够传入函数作为参数，也能够传入实现了该接口的结构体作为参数。
- 任何一个形如`func(key string) ([]byte, error)`的普通函数，只要使用`GetterFunc()`一包，就自动变成了一个实现了Getter接口的对象
- 接口 -> 方法 -> 函数

定义了一个接口 `Getter`，只包含一个方法 `Get(key string) ([]byte, error)`，紧接着定义了一个函数类型 `GetterFunc`，GetterFunc 参数和返回值与 Getter 中 Get 方法是一致的。而且 GetterFunc 还定义了 Get 方式，并在 Get 方法中调用自己，这样就实现了接口 Getter。所以 GetterFunc 是一个实现了接口的函数类型，简称为接口型函数。
