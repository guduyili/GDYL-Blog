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
