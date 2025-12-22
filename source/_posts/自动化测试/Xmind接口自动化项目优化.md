---
title: Xmind项目优化详情  
date: 2025-12-01
categories: 
- 自动化测试
tag:
- learning
---
<!-- toc -->

[TOC]



该优化流程由Gemini和Chatgpt倾情打造

# Xmindparser

 使用xmindparser来解析xmind文件时候，调用`xmind_to_dict`返回为Py中的列表(List)

1. 顶层结构：画布列表（List of Sheets）

   ```python
   [
   { /* 画布 1 的数据 */ },
   { /* 画布 2 的数据 (如果有) */ },
   ...
   ```

   ]

2. 画布字典结构（Sheet Dict）

   每个画布字典包含两个核心Key:

   - `title`:画布的名称（默认为“画布1”或“Sheet 1”）
   - `topic`:**根节点对象**，这是整个思维导图树状结构的入口

   ```python
   {
       "title": "画布 1", 
       "topic": { 
           /* 根节点数据，包含中心主题 */ 
       },
       "structure": "map" /* 有时包含结构类型 */
   }
   ```

3. 主题/节点结构（Topic Dict）核心部分

   所有的节点（无论是中心主题，分支主题还是子主题）都共享相同的数据结构，此为递归结构

   **一个节点字典通常包含**：

   - `title`: 节点显示的文字内容
   - `topics`：(List)子节点列表。如果该节点没有子节点，这个key可能不存在
   - `makers`: (List)图标/标记（如：优先级1，旗帜，笑脸等）
   - `note`:（String）节点的备注信息
   - `link`:（String）超链接

   

4. 完整的数据返回示例

   ![image-20251202205212186](./../../img/image-20251202205212186.png)

5. 

## Model







# 项目结构

```python
 2 ├── main.py               
    3 ├── core\                 
    4 │   ├── context.py         
    5 │   ├── evaluator.py      
    6 │   ├── models.py           
    7 │   └── parser.py        
    8 ├── test_dir\             
    9 │   ├── api_test.py        
   10 │   └── conftest.py        
   11 ├── utils\                  
   12 │   ├── base.py            
   13 │   └── logger.py           
   14 └── report\ 
```

- `main.py`:  启动器：清理报告 -> 运行测试 -> 生成Allure -> 自动打开
- `core`:   框架核心逻辑层
  - `context.py`:   上下文管理（变量/Session），运行时变量存储
  - `evaluator.py`:   处理变量替换 (${var}) 和 JMESPath 提取
  - `models.py`：数据模型定义 CaseData, StepData 标准结构
  - `parser.py`：  解析器 XMind -> CaseData
- `test_dir`:   执行Pytest
  - `api_test.py`:	通用测试用例模板 由fixture驱动
  - `conftest.py`：  Fixture定义，加载数据，初始化Runner
- `utils`：通用工具层
  - `base.py`:	核心执行器 Http请求，断言，Allure集成
  - `logger.py`:  日志配置
- `report`： 测试结果与报告产出



