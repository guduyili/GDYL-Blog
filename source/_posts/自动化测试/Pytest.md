---
title: Pytest       
date: 2025-06-06
categories: 
- 自动化测试
tag:
- learning

---

<!-- toc -->

[TOC]

## 测试用例的使用规则以及基础使用

- 模块名称必须以test_开头或以 _test结尾
- 测试了必须以Test开头，并且不能有init方法
- 测试方法必须以test开头

## pytest.ini

![image-20250609175443555](../../img/image-20250609175443555.png)

## 框架前后置处理

![image-20250610171444701](../../img/image-20250610171444701.png)

![image-20250610171550094](../../img/image-20250610171550094.png)

# 企业级框架学习

## 项目结构

![image-20250617105246363](../../img/image-20250617105246363.png)

## 功能详解：

本项目是一个基于Python的API自动化框架，它从XMind文件加载测试用例，通过执行它们的pytest，生产Allure报告

### main.py

**执行入口**
该文件负责清理旧报告、运行`pytest`并生成/展示Allure 结果。在`run()`函数中删除旧`report`目录后调用`pytest.main()`执行测试，再根据环境变量决定是否启动`allure serve`

### api_test.py

**单个测试函数**

定义了测试`test_unit_api` ，从夹具`cases_unit`获取用例。如果用例是`CaseFunc`类型则调用`BaseReq.req_func`，否则调用`BaseReq.req`处理接口请求

### conftest.py

**Pytest夹具与统计**

维护测试统计字典`test_statistics`，并在`pytest_runtest_makereporrt`钩子中统计通过/失败/跳过数量

`cases_unit`夹具负责读取并返回用例数据；`setups`夹具在会话级别完成设备连接及资源清理。钩子函数末尾再次记录测试执行情况

### cicd/result_processing.py

**结果整理**

从`conftest`获取`test_statistics`,生成包含总数，通过，跳过的字典并写入`result.txt`.同时提供读取，更新文件的函数

### utils/__ init __ .py

**公共工具**

- `get_logger`:配置`loguru`日志并同时向标准`logging`传递
- `Driver`统一初始化MySql，MongoDB，Redis，SSH，Kafka等连接
- `xrender`/`xrender_list`:递归替换用例参数中的变量
- `allure_step`等方法封装了Allure步骤与附件

### `utils/base.py`

**请求执行核心**

`BaseReq`类维护会话，数据连接及标签控制等信息，在`__init__`中读取配置并初始化Driver`req()`方法根据用例数据构造请求，包含token处理，文件上传下载，变量渲染，断言及灰/白/黑名单控制等逻辑

### `utils/loader.py`

**配置与用例解析**

负责读取`cfg.yaml`，根据配置加载XMind用例，处理环境信息，标签及端口映射，并将用例转换为`CaseFunc/CaseStep`对象。字符串和列表的变量替换也在此完成

### `utilsdatabase.py`

**数据库封装**

实现了 `MysqlDB`、`MongoDB`、`RedisDB` 三类数据库连接及基本操作，可通过跳板机方式连接 MySQL

### `utils/server_op.py`

**服务器和Kafka操作**

`ServerOp` 提供 SSH 执行命令、文件下载等功能；`KafkaRunner` 封装了生产/消费消息的逻辑

### 配置文件`cfg.yaml`

**运行及路径设置**

包含测试项目及报告路径等配置信息，在 `DataLoad.get_config()` 中读取

## 项目实际运行逻辑

执行入口（pytest.main） 
   ⬇
调用 test_unit_api 函数（pytest自动识别）
   ⬇
由 pytest fixture 注入用例数据（cases_unit）和初始化资源（setups）
   ⬇
调用 BaseReq.req 或 req_func 执行请求
   ⬇
收集并统计测试执行状态
   ⬇
结束后生成统计信息、报告

