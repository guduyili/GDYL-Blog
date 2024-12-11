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

