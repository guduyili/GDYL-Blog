---
title: Tortoise git
date: 2024-11-01
updated: 2024-11-01
categories: 
- git
tag: 
- learning
---

[TOC]

## 前言

#### 在配置tortoise的时候push和clone并不能正确使用而显示

```ABAP
No supported authentication methods available (server sent:publickey)
```

#### 通常表示 SSH 客户端和服务器之间没有找到匹配的身份验证方法。

#### 解决方案如下

- 打开 TortoiseGit 的设置 (`Settings`)。

- 在网络选项 (`Network`) 下，更改`SSH 客户端` 设置从 `PuTTY/Plink`。

  ```ABAP
  ..\Git\user\bin\ssh.exe
  ```

  
