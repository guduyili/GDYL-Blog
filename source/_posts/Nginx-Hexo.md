---
title: Nginx Hexo
date: 2024-11-06
updated: 2024-11-06
categories: 
- Linux
tag:
- learning
---

## 前言

#### 	之前使用nginx搭建了可以访问的图床，了解到了些许Nginx的简单使用，本次将详细解释Nginx的配置问题和使用其实现静态博客的搭建



## 1.Nginx的配置

### 1.1 从Git拉取项目

```bash
$ git clone <https>

$ cd <Hexo的项目位置>

$ npm install #根据package.json下载对应配置

$ hexo generate #在public文件生成静态文件

$ mkdir /var/www/gdylblog #创建Nginx将用于服务的文件

$ sudo cp -R public/* /var/www/gdylblog#将生成的public目录内容复制到Nginx其中
```

### 1.2 配置权限

```bash
$ sudo chown -R www-data:www-data /var/www/gdylblog

$ sudo chmod -R 755 /var/www/gdylblog
```

### 1.3配置server 具体内容

```bash
$ sudo nano /etc/nginx/sites-available/default

server {
    listen 80;
    listen [::]:80;
    server_name gdly.us.kg;  # 使用你的实际域名或服务器IP


    root /var/www/gdylblog;
    index index.html;

    location /{
         try_files $uri $uri/ =404;
        }
}
```



### 1.4建立符号链接

------

#### 1.4.1符号链接的含义

1. **软链接 vs 硬链接**：

   - **软链接（Symbolic Link）** ：是一个独立的文件，包含指向另一个文件或目录的路径。软链接可以跨不同的文件系统和卷。
   - **硬链接（Hard Link）** ：是指多个文件名指向相同的数据块，只有当所有硬链接被移除后，数据才会被删除。硬链接必须在同一个文件系统中。

2. **创建符号链接**：

   - 使用  **ln** 命令的  -**s** 选项来创建软链接。语法如下：

     ```
     ln -s [目标路径] [链接名]
     ```

   - **例如，命令 `sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default`**  

   - **在 `sites-enabled` 目录中创建一个名为 `default` 的符号链接，指向 `sites-available` 目录中的 `default` 配置文件。**

3. **符号链接的表现**：

   - 在命令行中，使用命令 `ls -l` 时，可以看到符号链接以 `->` 指示出链接的目标。

   - 删除符号链接不会影响原文件，仅删除链接本身。

     ------

#### 1.4.2 详细配置

```bash
$ ls -l /etc/nginx/sites-enabled/ 先查看存在的符号链接

lrwxrwxrwx 1 root root 34 Oct 13 09:13 default -> /etc/nginx/sites-available/default
#由于之前配置过图床所以已经存在符号链接不需要重新配置

#如果不存在符号链接
$ sudo ln -s /etc/nginx/sites-available/<your_site> /etc/nginx/sites-enabled/<your_site>

#如何删除符号链接：
$ sudo rm /etc/nginx/sites-enabled/<your_site>

$ sudo nginx -t
$ sudo systemctl reload nginx
```



