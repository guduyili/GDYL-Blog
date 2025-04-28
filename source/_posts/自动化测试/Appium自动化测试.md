---
title: Appium自动化测试       
date: 2025-03-03
updated: 2025-03-03
categories: 
- 自动化测试
tag:
- learning
---

<!-- toc -->

[TOC]

## ADB操作命令

### ADB的含义

ADB，即为Android Debug Bridge 是一种允许模拟器或已连接的Android设备进行通信的命令行工具，它可以为各种设备操作提供便利，如安装和调试应用，并提供对Unix shell(可用来在模拟器或链接的设备上运行各种命令) 的访问。可以在Android SDK/platform-tools中找到adb工具或下载ADB Kits

### ADB的作用

​		ADB是Android SDK里的一个工具，用这个工具可以直接操作管理Android模拟器或者真实的Android设备。它的主要功能有：

- 在设备上运行Shell命令；将本地APK软件安装至模拟器或Android设备；
- 管理设备或手机模拟器上的预定端口
- 在设备或手机模拟器上复制或粘贴文件

### ADB是一个客户端-服务器程序，包括三个组件

- 客户端：该组件发送命令。客户端在开发计算机上运行，您可以通过发出adb命令从命令行终端调用客户端
- 后台程序：该组件在设备上运行命令，后台程序在每个模拟器或设备实例上作为后台进程运行
- 服务器：该组件管理客户端和后台程序之间的通信。服务器在开发计算机上作为后台进程运行

### ADB命令语法

adb命令的基本语法如下

```
adb [-d|-e|-s <serial-number>] <command>
```

**多个设备/模拟器连接**

|                             参数                             |                           含义                           |
| :----------------------------------------------------------: | :------------------------------------------------------: |
|                              -d                              |      指定当前唯一通过USB连接的Android设备为命令目标      |
|                              -e                              |            指定当前唯一运行的模拟器为命令目标            |
|                              -s                              | <serial-number>指定相应设备序列号的设备/模拟器为命令目标 |
| 在多个设备/模拟器连接的情况下比较常用的是-s <serial-number>参数。serial-number是指设备的设备序列号，可以通过adb devices命令获取 |                                                          |

# 案例学习

```python
import time
from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from appium.webdriver.common.touch_action import TouchAction
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.actions import interaction
from selenium.webdriver.common.actions.action_builder import ActionBuilder
from selenium.webdriver.common.actions.pointer_input import PointerInput



# 配置Appium连接参数
desired_caps = {
    "platformName": "Android",
    "platformVersion": "你的系统版本",
    "deviceName": "你的设备名称",
    "appPackage": "com.ss.android.ugc.aweme",
    "appActivity": ".main.MainActivity",
    "noReset": True
}

# 连接Appium服务器
# driver = webriver.Remote('',desired_caps)
driver = webdriver.Chrome()
try:
    # 等待应用加载
    time.sleep(10)

    # 1. ID定位
    try:
        #
        element_by_id = driver.find_element(AppiumBy.ID,"com.ss.android.ugc/aweme:id/.")
        print("通过ID，定位成功")
    except Exception as e:
        print(f"通过ID定位失败：{e}")

    # 2. 类名定位
    try:
        element_by_class = driver.find_elements(AppiumBy.CLASS_NAME,"android.widget.TextView")
        print(f"通过类名定位到{len(element_by_class)}个元素")
    except Exception as e:
        print(f"通过类名定位失败：{e}")

    # 3. XPath定位
    try:
        element_by_xpath = driver.find_element(AppiumBy.XPath,'//android.widget.TextView[@text="你的文本"]')
        print(f"通过XPath定位成功")
    except Exception as e:
        print(f"通过XPath定位失败：{e}")

    #4. Accessibility ID定位
    try:
        element_by_accessibility_id = driver.find_element(AppiumBy.ACCESSIBILITY_ID,"your_accessibility_id")
        print(f"通过ACCESSIBILITY ID定位成功")
    except Exception as e:
        print(f"通过ACCESSIBILITY ID定位失败：{e}")

    #5. UIAutomator 定位（Android）
    try:
        element_by_uiautomator = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR,'new UiSelector().text("你的文本")')
        
```

