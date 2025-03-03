---
title: Seelenium自动化测试       
date: 2025-03-03
updated: 2025-03-03
categories: 
- 测试
tag:
- learning
---

<!-- toc -->

[TOC]

## Selenium

Selenium是一个用于自动化web应用程序测试的工具，它提供了一组工具和库，可以用多种编程语言（java，Python，C#）编写测试脚本，模拟用户在浏览器中的行为，如点击链接，填写表单，提交数据等。Selenium可以在各种浏览器上运行，包括Chrome，Firefox，Safari等，它还可以与其他测试框架和工具集成，帮助开发人员和测试人员自动化执行各种测试任务，提高测试效率和质量

### 初始化

```python
from selenium import webdriver
 
# 设置Chrome浏览器驱动程序的路径
chrome_driver_path = "D:\\chromedriver.exe"
 
# 初始化Chrome浏览器
browser = webdriver.Chrome(executable_path=chrome_driver_path)
```

**所以，我们在浏览器上设置的东西，也可以通过代码实现设置好**

比如：

- 浏览器下载文件后，下载的地址设置
- 浏览器是否加载图片
- 浏览器是否禁用JS
- 浏览器是否使用隐私模式
- 浏览器是否使用缓存

等等...