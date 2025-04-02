---
title: Selenium自动化测试       
date: 2025-03-03
updated: 2025-03-03
categories: 
- 自动化测试
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

### 三大定位

- **`隐式等待：`**指定一个时间，Selenium将在查找元素时等待一定时间，如果在指定的时间内找到了元素，则继续执行，如果超过了指定是见仍未找到元素，则抛出NoSuchElementException异常。

```python
browser.implicately_wait（秒数）
```

- **`显示等待：`**在查找元素时，根据条件等待一定的时间，等待条件成立后再继续执行，可以指定等待的最长时间和轮询周期

```python
from telnetlib import EC

from selenium.webdriver.common.by import By
from selenium.webdriver.common.devtools.v131 import browser
from selenium.webdriver.support.ui import WebDriverWait


#最多等待10秒直到元素出现
#等待时间内没有找到元素超时会抛出TimeoutException
WebDriverWait(browser,10).until(EC.presence_of_element_located((By.XPATH,'')))


#还可以等待这个元素不出现
WebDriverWait(browser,10).until_not(EC.presence_of_element_located((By.XPATH,'')))
#等地时间内找到元素超时会抛出TimeoutException

#二者唯一区别为until和until_not
```

- **`强制等待：`**比较稳定，线程停止，等待固定时间之后再执行脚本

```python
time.sleep(秒数)
```

### 多窗口事件

1. 获取当前窗口句柄：在打开新窗口之前，先获取当前窗口的句柄。

```java
String parentWindowHandle = driver.getWindowHandle()
```

​	2.打开新窗口：执行打开新窗口的操作，例如点击连接或按钮，打开一个新的窗口

​	3.获取所有窗口句柄：获取所有窗口的句柄，包括当前窗口和新打开的窗口。

```java
Set<String> allWindowHandles = driver.getWindowHandles()
```

​	4.切换到新窗口，遍历所有窗口句柄，判断哪个窗口句柄不等于当前窗口句柄，然后切换到该窗口

```java
for(String windowHandle : allWindowHandles){
    if (!windowHanle.equals(parentWindowHandle)){
		driver.switchTo().window(windowHandle);
        break;
	}
}
```

​	5.在新窗口中执行操作：切换到新窗口后，可以执行在新窗口中需要的操作

​	6.切换回原窗口：操作完成后，切换回原来的窗口

```java
driver.switchTo().window(parentWindowHandle);
```



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

# Python + Selenium实现百度搜索脚本

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

# Python + selenium +unittest + HTMLTestRunner

百度搜索：

文件结构树

```
├─test_case
│  │  LeapYear.py
│  │  test_baidu.py
│  │  test_leap_year.py
│  │  __init__.py
│  │
│
└─test_report
        result.html
        __init__.py
│
└─run_tests.py
```

test_baidu.py

```python
import unittest
from time import sleep

from selenium import webdriver
from selenium.webdriver.common.by import By


class TestBaidu(unittest.TestCase):
    """ 百度搜索测试 """

    @classmethod
    def setUpClass(cls) :
        cls.driver = webdriver.Chrome()
        cls.base_url = "https://www.baidu.com"

    def baidu_search(self,search_key):
        self.driver.get(self.base_url)
        self.driver.find_element(By.ID, "kw").send_keys(search_key)
        self.driver.find_element(By.ID, "su").click()
        sleep(2)
    def test_search_key_jwby(self):
        """" 搜索关键字：姜维伯约 """
        search_key = "姜维伯约"
        self.baidu_search(search_key)
        self.assertEqual(self.driver.title,search_key+"_百度搜索")

    def test_search_key_unitest(self):
        """" 搜索关键字：unittest """
        search_key = "unittest"
        self.baidu_search(search_key)
        self.assertEqual(self.driver.title,search_key+"_百度搜索")

    @classmethod
    def tearDownClass(cls):
        cls.driver.quit()
```

run_tests.py

```python
import  unittest
from XTestRunner import  HTMLTestRunner
import time
test_dir = './test_case'
suites = unittest.defaultTestLoader.discover(test_dir, pattern='test*.py')

if __name__ == '__main__':
    # runner = unittest.TextTestRunner(verbosity=2)  # 增加详细程度
    # runner.run(suites)

    # 获取当前日期时间
    now_time = time.strftime("%Y-%m-%d %H_%M_%S")

    #生成HTML格式报告
    fp = open('./test_report/' + now_time + 'result.html', 'wb')
    runner = HTMLTestRunner(stream=fp,
                            title="百度搜索测试报告",
                            description="运行环境: Windows 10, Chromr 浏览器"
                            )
    runner.run(suites)
    fp.close()
```

## Parameterized

通过Parameterized实现参数化

```python
@parameterized.expand([
    ("case1", "selenium"),
    ("case1", "unittest"),
    ("case1", "parameterized"),
])
def test_search(self, name, search_key):
    self.baidu_search(search_key)
    self.assertEqual(self.driver.title, search_key+"_百度搜索")
```

## DDT

```python
# 参数化使用方式一
 @data(["case1", "selenium"], ["case2", "ddt"], ["case3", "python"])
 @unpack
 def test_search1(self, case, search_key):
 print("第一组测试用例：", case)
 self.baidu_search(search_key)
 self.assertEqual(self.driver.title, search_key + "_百度搜索")
 # 参数化使用方式二
 @data(("case1", "selenium"), ("case2", "ddt"), ("case3", "python"))
 @unpack
 def test_search2(self, case, search_key):
 print("第二组测试用例：", case)
 self.baidu_search(search_key)
 self.assertEqual(self.driver.title, search_key + "_百度搜索")
 # 参数化使用方式三
 @data({"search_key": "selenium"}, {"search_key": "ddt"}, {"search_key":
 "python"})
 @unpack
 def test_search3(self, search_key):
 print("第三组测试用例：", search_key)
 self.baidu_search(search_key)
 self.assertEqual(self.driver.title, search_key + "_百度搜索")
```

