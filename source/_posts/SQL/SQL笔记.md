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

[toc]



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


## DML

- DEL英文全称Data Manipulation Language(数据操作语言)，用来对数据库中表的数据记录进行增，删，改。



### DML-insert

```sql
-- 指定字段添加数据
insert into 表名（字段名1，字段名2） values （值1，值2）;

-- 全部字段添加数据
insert into 表名 values （值1，值2....）;

-- 批量删除数据（指定字段）
insert into 表名（字段名1，字段名2） values （值1，值2）, （值1，值2）;

-- 批量添加数据（全部字段）
insert into 表名 values （值1，值2....）,（值1，值2....）;
```

### DML-update

````sql
-- 修改数据
update 表名 set 字段名1 = 值1,字段名2 = 值2, ...[where 条件];
````

###  DML-delete

```sql
-- 删除数据
delete from 表名 [where 条件];
```



## DQL

- DQL英文全称为Data Query Language (数据查询语言)，用来查询数据库表中的记录
- 关键字：SELECT



- 完整的DQL语句语法：

  ```sql
  select		字段列表
  
  from		表名列表
  
  where		条件列表
  
  group by	分组字段列表
  
  having		分组后条件列表
  
  order by	排序字段列表
  
  limit		分页参数
  ```

  

### DQL-基本查询

```sql
-- 查询多个字段
select 字段1,字段2,字段3, from 表名;

-- 查询所有字段（通配符）
select * from 表名;

-- 为查询字段设置别名，as关键字可以省略
select 字段1 [as 别名1], 字段2 [as 别名2] from 表名;

-- 去除重复记录
select distinct 字段列表 from 表名;
```

### DQL-条件查询

```sql
-- 条件查询
select 字段列表 from 表名 where 条件列表;

is null, is not null
<> == !=
_: 单个字段；
%： 任意个字符
多个查询条件：and/or
```

### DQL-分组查询

- 聚合函数：将一列数据作为一个整体，进行纵向计算。

| 函数  | 功能     |
| ----- | -------- |
| count | 统计数量 |
| max   | 最大值   |
| min   | 最小值   |
| avg   | 平均值   |
| sum   | 求和     |

1. null值不参与所有聚合函数的运算。
2. 统计数量可以使用：count(*)  count(字段) count(常量) ，推荐使用count(*)。

```sql
-- 分组查询
select 字段列表 from 表名 [where 条件列表] group by 分组字段名 [having 分组后过滤条件];
```

- where 和 having的区别：
  1. 执行时机不同：where是分组之前进行过滤，不满足where条件，不参与分组；而having是分组之后对结果进行过滤。
  2. 判断条件不同：where不能对聚合函数进行判断，而having可以。

### DQL-排序查询

```sql
-- 排序查询
select 字段列表 from 表名 [where 条件列表] [group by 分组字段名 having 分组后过滤条件] order by 排序字段 排序方式;
```

- 排序方式：升序（asc），降序（desc）；默认为升序asc，是可以不写的。

  如果是多字段排序，当第一个字段值相同时，才会根据第二个字段进行排序。

### DQL-分页查询

```sql
-- 排序查询
select 字段列表 from 表名 [where 条件] [group by 分组字段名 having 过滤条件] [order by 排序字段] limit 起始索引,查询记录数;
```

1. 起始索引从0开始。
2. 分页查询是数据库的方言，不同数据库有不同的实现，MYSQL中是LIMIT。
3. 如果起始索引为0，起始索引可以省略，直接简写为limit 10。

## JDBC

- 连接和操作数据库的一种API

```java
public class jdbcTest {
    /**
     * JDBC入门程序
      */
    @Test
    public void testUpdate() throws Exception {
        //1.注册驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        //2.获取数据库的链接
        String url = "jdbc:mysql://localhost:3306/db1";
        String username = "root";
        String password = "1412";
        Connection connection = DriverManager.getConnection(url,username,password);

        //3.获取SQL语句执行对象
        Statement statement = connection.createStatement();

        //4.执行SQL
        int tmp = statement.executeUpdate("update employee set NAME = \"姜维伯约\" WHERE id= 1");//DML
        System.out.println("SQL执行记录" + tmp);

        //5.释放资源
        statement.close();
        connection.close();
    }
}

```

```xml
<!--pom.xml--> 
<dependencies>

        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.0.33</version>
        </dependency>


        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.11.3</version>
            <scope>test</scope>
        </dependency>


        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.36</version>
        </dependency>
    </dependencies>
```

## MyBatis

### 数据库连接池

- 容器，负责分配，管理数据库连接（Connection）
- 优势：资源复用，提升系统响应速度
- 接口：DataSource

### 删除用户-delete

|   符号    | 说明                                                         |                             场景                             |                            优缺点 |
| :-------: | :----------------------------------------------------------- | :----------------------------------------------------------: | --------------------------------: |
|  **#{}**  | `#` 用于将参数作为**预编译的占位符**处理，底层会将参数值绑定为 SQL 语句中的参数 | 将参数值安全地插入到 SQL 语句中，MyBatis 会在执行时将 `#{}` 替换为对应的占位符（如 `?`），然后通过 JDBC 将实际的值绑定进去。 | 这种方式能够有效防止 SQL 注入问题 |
| **`${}`** | 参数会以字符串形式直接拼接到 SQL 中                          |             动态传递表名、列名等非值的 SQL 片段              |         不安全，容易导致 SQL 注入 |

```java
@Delete("delete from user where id = #{id}")
```

### 新增用户-insert

- 添加新用户

```java
 @Insert("insert into user(id, username, NAME, age,gender) VALUE (#{id},#{username},#{name},#{age},#{gender})")
```



### 修改用户-update

- 根据id更新用户信息

```java
  @Update("update user set username = #{username} , NAME = #{name} ,age = #{age} where id = #{id}")
```

### 查询用户-select

- 根据用户名和密码查询用户信息

```java
    @Select("select * from user where username = #{username} and name = #{name}")
    public User select(@Param("username")String username,@Param("name")String name);
```

- @Param注解的作用是为接口的方法形参起名字
- 基于官方骨架创建的springboot项目中，接口编译时会保留方法形参名，@Param注解可以省略

### XML

- 在Mybatis中，既可以通过配置SQL语句，也可以通过XML配置文件配置SQL语句

- 默认规则：

  1. XML映射文件的名称和Mapper接口名称一致，并且将XML映射文件和Mapper接口放置在想同包下（**同包同名**）
  2. XML映射文件的namespace属性为Mapper接口全限定名一致
  3. XML映射文件中sql语句的id与Mapper接口中的方法名一致，并保持返回类型一致

  

### application.properties

```properties
spring.application.name=spring-boot-mybatis-quickstart


#配置数据库连接信息
spring.datasource.url=jdbc:mysql://localhost:3306/db1
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.username =root
spring.datasource.password = 1412


#配置mybatis的日志输出
mybatis.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl

```

### application.xml

```java
spring:
  application:
    name: spring-boot-mybatis-quickstart



  datasource:
    type: com.zaxxer.hikari.util.DriverDataSource
    url: jdbc:mysql://localhost:3306/db1
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password: 1412

#Mybatis
mybatis:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  mapper-locations: classpath:mapper/*.xml

```

