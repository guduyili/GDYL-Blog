---
title: LangChain_Learning
date: 2026-02-08
categories: 
- AI
tag:
- AI
---

<!-- toc -->

[TOC]

# LangGraph Agent 入门指南

```python
"""LangGraph Agent 完整实现示例 (带详细注释版)

这份代码是一个完整的 LangGraph Agent 教程。
它展示了如何构建一个能够使用工具（加法、乘法）的 AI 代理。

核心概念：
1. **Nodes (节点)**: 代理的思考 (LLM) 和行动 (Tool) 单元。
2. **Edges (边)**: 定义流程的跳转逻辑。
3. **State (状态)**: 在节点间传递的数据，主要是消息历史。
"""

from __future__ import annotations
from typing import Annotated, Literal
from typing_extensions import TypedDict

# LangGraph 核心组件
# StateGraph: 用于构建状态图的类
# START, END: 特殊的图节点，分别代表流程的开始和结束
# MessagesState: 预定义的状态类型，自动处理消息列表的存储
from langgraph.graph import StateGraph, START, END, MessagesState
from langgraph.prebuilt import ToolNode

# LangChain 核心
from langchain_core.messages import HumanMessage, AIMessage, ToolMessage
from langchain_core.tools import tool


# ==================== 1. 定义工具 ====================
# 使用 @tool 装饰器将普通 Python 函数转换为 LangChain 可用的工具
@tool
def add(a: int, b: int) -> int:
    """加法工具：计算两个整数的和。
    
    Args:
        a: 第一个整数
        b: 第二个整数
    """
    result = a + b
    print(f"🔧 [行动] 调用加法工具: {a} + {b} = {result}")
    return result


@tool
def multiply(a: int, b: int) -> int:
    """乘法工具：计算两个整数的积。
    
    Args:
        a: 第一个整数
        b: 第二个整数
    """
    result = a * b
    print(f"🔧 [行动] 调用乘法工具: {a} * {b} = {result}")
    return result


# ==================== 2. 模拟 LLM ====================
# 在实际项目中，这里会使用 ChatOpenAI 或 ChatAnthropic
# 为了演示方便，我们手动实现一个简单的模拟 LLM
class MockLLM:
    """模拟的语言模型，用于测试流程而不消耗 API Token"""
    
    def __init__(self, tools):
        self.tools = tools
        self.call_count = 0
    
    def invoke(self, messages):
        """模拟 LLM 的思考过程"""
        self.call_count += 1
        last_message = messages[-1]
        
        print(f"\n🤖 [思考] LLM 第 {self.call_count} 次被调用")
        print(f"   输入消息: {last_message.content if hasattr(last_message, 'content') else str(last_message)[:50]}...")
        
        # 场景模拟：第一次调用，用户说 "Add 3 and 4"
        # LLM 应该决定调用 'add' 工具
        if self.call_count == 1 and isinstance(last_message, HumanMessage):
            # 简单的关键词匹配模拟理解能力
            if "add" in last_message.content.lower() or "3" in last_message.content:
                print("   👉 决策: 决定使用工具 'add'")
                return AIMessage(
                    content="", # 思维链内容通常放在这里，这里留空
                    tool_calls=[{
                        "name": "add",
                        "args": {"a": 3, "b": 4},
                        "id": "call_001" # 唯一的调用 ID
                    }]
                )
        
        # 场景模拟：第二次调用，收到了工具的运行结果
        # LLM 应该综合工具结果生成最终回答
        if self.call_count == 2:
            # 检查历史消息中是否有 ToolMessage
            tool_messages = [m for m in messages if isinstance(m, ToolMessage)]
            if tool_messages:
                result = tool_messages[-1].content
                print(f"   👉 决策: 收到工具结果 '{result}'，生成最终回答")
                return AIMessage(
                    content=f"计算完成！3 + 4 = {result}",
                    tool_calls=[]  # 任务完成，不再调用工具
                )
        
        # 默认兜底回复
        return AIMessage(content="我完成了任务。", tool_calls=[])


# ==================== 3. 定义节点函数 ====================
# 节点是图中的执行单元，接收当前状态，返回更新后的状态

def llm_call(state: MessagesState):
    """思考节点：调用 LLM 生成回复或工具调用请求"""
    print("\n📍 [节点] 进入 llm_call (思考阶段)")
    messages = state["messages"]
    
    # 调用 LLM
    response = mock_llm.invoke(messages)
    
    # 返回更新：LangGraph 会将这里的 'messages' 列表追加到全局状态中
    return {"messages": [response]}


def should_continue(state: MessagesState) -> Literal["tool_node", "__end__"]:
    """路由逻辑：决定下一步是执行工具还是结束"""
    messages = state["messages"]
    last_message = messages[-1]
    
    # 检查最后一条消息是否包含工具调用请求
    if hasattr(last_message, "tool_calls") and last_message.tool_calls:
        print(f"\n🔀 [路由] 检测到工具调用请求 -> 跳转到 'tool_node'")
        return "tool_node"
    
    print(f"\n🔀 [路由] 无工具调用 -> 流程结束 (END)")
    return END


# ==================== 4. 构建 Agent 图 ====================
print("=" * 60)
print("🏗️  正在构建 LangGraph Agent...")
print("=" * 60)

# (1) 准备工具列表
tools = [add, multiply]

# (2) 创建工具节点
# ToolNode 是 LangGraph 预置的节点，它能自动执行 tool_calls 并返回 ToolMessage
tool_node = ToolNode(tools)

# (3) 初始化模拟 LLM
mock_llm = MockLLM(tools)

# (4) 创建状态图构建器
# 使用 MessagesState 作为状态类型
agent_builder = StateGraph(MessagesState)

# (5) 添加节点
agent_builder.add_node("llm_call", llm_call)   # 思考节点
agent_builder.add_node("tool_node", tool_node) # 行动节点

# (6) 添加边 (定义流程)

# 起点 -> 思考
# 无论何时开始，总是先让 LLM 思考
agent_builder.add_edge(START, "llm_call")

# 思考 -> ? (条件跳转)
# 思考结束后，根据 should_continue 的结果跳转
agent_builder.add_conditional_edges(
    "llm_call",         #以此节点结束时触发
    should_continue,    # 路由函数
    {
        "tool_node": "tool_node",  # 函数返回 "tool_node" 时去这里
        END: END                   # 函数返回 END 时结束
    }
)

# 行动 -> 思考 (循环)
# 工具执行完后，必须回到 LLM 让他看结果
agent_builder.add_edge("tool_node", "llm_call")

# (7) 编译图
# 编译后的 agent 就是一个可调用的 Runnable 对象
agent = agent_builder.compile()

print("✅ Agent 构建完成！图结构已就绪。")


# ==================== 5. 运行测试 ====================
print("\n" + "=" * 60)
print("🧪 开始运行测试: 用户输入 'Add 3 and 4'")
print("=" * 60)

# 构造初始消息
messages = [HumanMessage(content="Add 3 and 4.")]

# 运行 Agent
# invoke 会触发图的执行，直到遇到 END
result = agent.invoke({"messages": messages})

print("\n" + "=" * 60)
print("📊 最终对话历史回顾")
print("=" * 60)

# 打印完整的对话历史
for i, m in enumerate(result["messages"], 1):
    role = "👤 用户" if isinstance(m, HumanMessage) else \
           "🤖 AI " if isinstance(m, AIMessage) else \
           "🔧 工具"
    
    content = m.content
    if isinstance(m, AIMessage) and m.tool_calls:
        content += f" [请求调用工具: {m.tool_calls[0]['name']}]"
    
    print(f"[{i}] {role}: {content}")

print("\n" + "=" * 60)
print("✅ 教程演示结束！")
print("=" * 60)
```

## 1.核心概念

langgraph是一个用于构建**有状态，多参与者**的应用程序的库，核心思想是将Agent的工作流看作是一个图

- 节点（Nodes）：执行具体工作的单元（例如：调用LLM，执行工具）
- 边（Edges）：定义节点之间的流向（例如：从LLM节点流向工具节点）
- 状态（State）：再节点之间传递懂得数据（例如：聊天记录Messages）

![image-20260211120248204](./../../img/image-20260211120248204.png)

## 运行轨迹分析

当你运行 `python 2.py` 时，控制台会打印出每一步的决策过程。以下是一次完整的执行轨迹解析：

### 第一阶段：接收任务与初步思考

```
📍 [节点] 进入 llm_call (思考阶段)

🤖 [思考] LLM 第 1 次被调用

   👉 决策: 决定使用工具 'add'
```

- **解读**：用户输入 "Add 3 and 4"。LLM 分析后发现自己算不准（或者是被设定为必须用工具），于是生成了一个 `tool_calls` 请求。

### 第二阶段：路由与行动

```
🔀 [路由] 检测到工具调用请求 -> 跳转到 'tool_node'

🔧 [行动] 调用加法工具: 3 + 4 = 7
```

- 解读`should_continue` 函数看到了`tool_calls`，指挥流程走向`tool_node`工具执行后，结果`7`被封装成`ToolMessage`存入状态。

### 第三阶段：再次思考与完结

```
📍 [节点] 进入 llm_call (思考阶段)

🤖 [思考] LLM 第 2 次被调用

   👉 决策: 收到工具结果 '7'，生成最终回答

🔀 [路由] 无工具调用 -> 流程结束 (END)
```

- **解读**：LLM 看到了工具及工具的返回结果。它整合信息，生成自然语言回复 "计算完成！3 + 4 = 7"。路由函数检测到没有新的工具调用了，于是结束流程。