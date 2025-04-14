---
title: Jenkins       
date: 2025-04-10
updated: 2025-04-10
categories: 
- 自动化测试
tag:
- learning
---

<!-- toc -->

[TOC]

## 具体配置

![image-20250411100653451](https://s2.loli.net/2025/04/11/LhBCYtxwVHKdAZM.png)

![image-20250411100737054](https://s2.loli.net/2025/04/11/kxi2RoBmlF1y79w.png)

![image-20250411100834478](https://s2.loli.net/2025/04/11/o6dSqTMBrk57fvt.png)

![image-20250411100808196](https://s2.loli.net/2025/04/11/u6CS9N8QFHsIyUw.png)

## 发送邮件失败 An attempt to send an e-mail to empty list of recipients, ignored

### Default Recipients

1. 通过Manage Jenkins进入Configure System
2. 查看Default Recipients这一栏是否填写了收件人

### Project Recipient List

1. 进入具体的Job
2. 查看Post-build Actions里有没有添加Editable Email Notification这个功能
3. 不要勾选Disable Extended Email Publisher这个选项栏
4. 查看Project Recipient List这一栏有没有填写收件人

### Recipient List

1. 还是进入Editable Email Notification这一栏
2. 点击进入右下角Advanced Settings...
3. 查看Triggers这一栏有没有设置对应触发条件，比如Failure-Any和Success
4. 默认的Developers不会发送给收件人，需要选择Recipient List

## Python jenkinsapi库

```python
# 从 jenkinsapi.jenkins 模块导入 Jenkins 类，用于与 Jenkins 服务器进行交互
from jenkinsapi.jenkins  import Jenkins

# 创建一个 Jenkins 对象，用于连接到指定的 Jenkins 服务器
# 'http://47.108.143.107:8082' 是 Jenkins 服务器的地址
# username='admin' 是用于登录 Jenkins 服务器的用户名
# password='1412050416Lz@' 是对应的密码
# use_crumb=True 表示使用 CSRF 保护机制，确保请求的安全性
jk = Jenkins('http://47.108.143.107:8082', username='admin',
             password='1412050416Lz@', use_crumb=True)

# 定义要操作的 Jenkins 任务名称
job_name = 'test2'

# 检查 Jenkins 服务器上是否存在指定名称的任务
if jk.has_job(job_name):
    # 如果任务存在，通过任务名称获取该任务的对象
    my_job = jk.get_job(job_name)
    # 检查该任务是否正在队列中等待执行或者正在运行
    if not my_job.is_queued_or_running():
        try:
            # 尝试获取该任务的最后一次构建的编号
            last_build = my_job.get_last_buildnumber()
        except:
            # 如果获取失败（例如还没有任何构建记录），将最后一次构建编号设为 0
            last_build = 0
        # 计算下一次构建的编号，即最后一次构建编号加 1
        build_number = last_build + 1

        # 启动指定名称的 Jenkins 任务
        try:
            jk.build_job(job_name)
        except Exception as e:
            # 如果启动任务时出现异常，打印异常信息
            print(str(e))

        # 进入一个无限循环，持续检查任务的状态
        while True:
            # 检查任务是否不再处于队列中等待执行或者正在运行的状态
            if not my_job.is_queued_or_running():
                # 如果任务已经完成，打印提示信息
                print("Finished")
                # 打印本次启动的构建编号
                print(f"build_num:{build_number}")
                # 跳出循环，结束程序
                break
                
# Finished
# build_num:12


```
