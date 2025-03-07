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

### 浏览器不自动关闭

```python
import time

from selenium import webdriver

#让浏览器不自动关闭
options  = webdriver.ChromeOptions()
options.add_experimental_option('detach', True)

#创建浏览器对象
driver = webdriver.Chrome(options=options)
driver.get('https://www.baidu.com/')
# time.sleep(5)
# driver.quit()

```

### 八大元素定位

定位的前提：

​		唯一

定位的方式：

​		ID（底层转CSS_SELECTOR)）

​		NAME（底层转CSS_SELECTOR)）

​		LINK_TEXT

​		PAPTIAL_LINK-TEXT

​		XPATH

​		CSS_SELECTOR

​		TAG_NAME（基本用不了，不可能唯一）

​		CLASS_NAME（底层转CSS_SELECTOR)）

实际的方法：

​		driver.find_element		定位一个元素

​		driver.find_elements		定位多个元素

实际的方式：两种

​		XPATH

​		CSS_SELECTOR（1.语法比较复杂，2.定位比较长，3.不能覆盖LINK_TEXT和PARTIAL_LINK_TEXT）

### XPATH

1.绝对路径，以/开头

/html/body/section/main/div[1]/div/div[2]/div[1]/div[3]/div/div[2]/section/div[10]/div/div[3]/div[1]/div/span/span/span

2.相对路径，以//开头

​		相对路径+属性定位

​				单属性定位：	//input[@name="username"]		//input[@type="submit"]

​				多属性定位：	//input[@type="submit" and value=""]

​		相对路径+部分属性定位

​				//input[starts-with(@value="")]

​				//input[contains(@value="")]

​		相对路径+文本值定位：（替换LINK_TEXT，PARTIAL_LINK_TEXT）

​				//a[text()=""]（）

​		相对路径+通配符定位：

​				//*[text()=""]

​				//*[@type=""]

### 框架

frame: 	框架（房间）：如果元素在房间里面，那么就必须先进入框架才能定位

iframe：子框架（房间）：如果元素在房间里面，那么就必须先进入框架才能定位

![image-20250305144832115](https://s2.loli.net/2025/03/05/UPxeuTsNASVHXa2.png)

1. 框架处理

```python
#进入框架
driver.switch_to.frame("menu-frame")
  
#出框架
driver.switch_to.default_content()

#进入框架
driver.switch_to.frame("main-frame")
```

​	2.下拉框Select

```python
```

## Demo

### Python + Selenium实现百度搜索脚本

```python
import os
import time
from urllib import request


import random
from sys import executable

import requests
from selenium import webdriver
from selenium.webdriver import Keys
from selenium.webdriver.common.by import By


def main():
    driver_path = 'chromedriver'
    driver = webdriver.Chrome()

    try:
        driver.get('https://www.baidu.com')

        search_box = driver.find_element(By.ID, 'kw')
        #search_box = driver.find_element(By.NAME, 'wd')

        search_box.send_keys('背景图片')

        search_box.send_keys(Keys.RETURN)
        time.sleep(3)


        #模拟向下滑动页面
        for i in range(3):
            driver.execute_script("window.scrollBy(0,500)")
            time.sleep(1)

        #获取搜索结果中的所有链接
        search_result = driver.find_elements(By.CSS_SELECTOR, 'h3.t a')

        if search_result:
            #随机选择一个链接
            random_result = random.choice(search_result)
            random_result.click()
            time.sleep(3)

            #找到页面中的一张图片
            images  = driver.find_elements(By.TAG_NAME, 'img')
            if images:
                image = random.choice(images)
                image_url = image.get_attribute('src')

                if image_url:
                    image_name = image_url.split('/')[-1]
                    # 确保目录存在
                    os.makedirs('workspace/log', exist_ok=True)
                    image_path = os.path.join('workspace/log',image_name)
                    response = requests.get(image_url)
                    with open(image_path, 'wb') as f:
                        f.write(response.content)
                        print(f"图片已经下载导：{image_path}")


    finally:
        driver.quit()
if __name__ == '__main__':
    main()
```
