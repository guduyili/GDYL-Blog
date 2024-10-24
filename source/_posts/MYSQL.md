---
title: MYSQL
date: 2024-09-24
updated: 2024-09-24
categories: 
- SQL
tag:
- learning
---

## MYSQL

### 1.打开命令提示符
### F: cd F:\mysql-8.0.20-winx64\bin

``` bash
$ netstat -an | findstr 3306
```


``` bash
   MySQL 服务监听端口
   端口信息
   使用 netstat 命令和 findstr 命令列出了 MySQL 服务监听的端口。
   监听端口列表
   MySQL 服务监听以下端口：

   3306: 这是 MySQL 服务的默认监听端口，用于 TCP 协议。
   33060: 这是 MySQL 服务的二进制协议监听端口。
   连接信息
   以下是连接信息：

   ::1:3306: 这是 IPv6 地址和端口 3306 的连接。
   ::1: 这是 IPv6 地址，指示连接来自本地主机。
   连接状态
   连接状态如下：

   LISTENING: 服务正在监听该端口。
   ESTABLISHED: 服务正在处理该连接。
   TIME_WAIT: 服务正在等待连接的关闭。
   0.0.0.0:0: 该连接的本地 IP 地址和端口号为 0.0.0.0 和 0，指示连接来自外部主机。
   MySQL 服务已经正常运行，正在监听端口 3306 和 33060。
```