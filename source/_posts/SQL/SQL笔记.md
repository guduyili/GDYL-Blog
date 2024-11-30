---
title: SQL笔记
date: 2024-11-12
updated: 2024-11-29
categories: 
- SQL
tag:
- learning
---

<!-- toc -->

- SQL：一门操作关系型数据库的编辑语言，定义操作所有关系型数据库的统一标准

- 分类：

  | 分类 | 全程                       | 说明                                                   |
  | ---- | -------------------------- | ------------------------------------------------------ |
  | DDL  | Data Definition Language   | 数据定义语言，用于定义数据库对象（数据库，表，字段）   |
  | DML  | Data Manipulation Language | 数据操作语言，用来对数据库表中的数据进行增删改         |
  | DQL  | Data Query Language        | 数据查询语言，用来查询数据库中表的记录                 |
  | DCL  | Data Control Language      | 数据控制语言，用来创建数据库用户，控制数据库的访问权限 |

  

## DDL-数据库

```sql
--查询所有数据库
show databases;

--查询当前数据库
select database();

--使用/切换数据库
use 数据库名;

--创建数据库
create database [if not exists] 数据库名 [default charset utf8mb4];

--删除数据库
drop database [if exists] 数据库名;

```

- 创建表的语法：

  ```sql
  create table tablename{
  	字段1 字段类型 [约束] [comment 字段1注释]
  	.....
  	字段2 字段类型 [约束] [comment 字段2注释]
  }[comment 表注释];
  
  -- 创建表格
  CREATE TABLE user(
  		id INT COMMENT 'ID,唯一标识',
  		username VARCHAR(10) COMMENT '用户名',
  		NAME VARCHAR(10) COMMENT '姓名',
  		age INT COMMENT '年龄',
  		gender CHAR(1) COMMENT '性别'
  )COMMENT '用户信息表';
  
  -- 创建表（约束）
  CREATE TABLE user1(
  		id INT  PRIMARY KEY auto_increment COMMENT 'ID,唯一标识',-- 主键约束 auto_increment表示为自动增长
  		username VARCHAR(10) not null UNIQUE COMMENT '用户名', -- 非空 唯一
  		NAME VARCHAR(10)  not NULL COMMENT'姓名', -- 非空
  		age INT COMMENT '年龄',
  		gender CHAR(1) DEFAULT '男' COMMENT '性别' -- 默认
  )COMMENT '用户信息表';
  ```

### DDL-表结构-创建

- 约束： 约束是作用于表中字段上的规则，用于限制存储在表中的数据。
- 目的： 保证数据库中数据的正确性，有效性和完整性。

| 约束     | 描述                                             | 关键字      |
| -------- | ------------------------------------------------ | ----------- |
| 非空约束 | 限制该字段值不能为null                           | not null    |
| 唯一约束 | 保证字段的所有数据都是唯一，不重复的             | unique      |
| 主键约束 | 主键是一行数据的唯一标识，则采用默认值           | primary key |
| 默认约束 | 保存数据时，如果未指定该字段值，则采用默认值     | default     |
| 外键约束 | 让两张表的数据建立连接，保证数据的一致性和完整性 | foreign key |

### DDL-表结构

- 数据类型

  MySQL中的数据类型有很多，主要分为三类：数值类型，字符串类型，日期时间类型。

1. 数值类型在定义的时候，后面加了unsigned关键字是什么意思
   - unsigned表示无符号类型，表示只能取0及正数
   - 不加默认是signed，表示可以取复数

### DDL-表结构-查询，修改，删除

- 表结构的查询，修改，删除相关语法如下：

  ```sql
  show tables; -- 查询当前数据库的所有表
  desc 表名; -- 查询表结构
  show create table 表名; -- 查询建表语句
  
  
  alter table 表名 add 字段名 类型（长度）[comment 注释][约束]; -- 添加字段
  alter table 表名 modify 字段名 新数据类型（长度）; -- 修改字段类型
  alter table 表名 change 旧字段名 新字段名 类型（长度）[comment 注释][约束]; -- 修改字段名字与字段类型
  alter table 表名 drop column ; -- 删除字段
  alter table 表名 rename to 新表名; -- 修改表名
  
  drop table [if exists] 表名; -- 删除表
  ```

  
