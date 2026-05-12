---
title: AIagent_Learning
date: 2026-05-12
categories: 
- AI
tag:
- AI
---

<!-- toc -->

[TOC]

# DeepResearch_Learning


## Task Tool Payload Event
- Task： 触发Tool，Task是用户主题被拆解后的子研究任务，执行时LLM在`summarize_task`里调用`NoteTool`
- Tool 执行 → 产生原始 payload（输入型）：
`NoteTool.run(params)` 执行完后，`ToolAwareSimpleAgent` 自动组装一个输入型 `payload` 回调 `tracker.record：`
- record()解析，生成Event（内部事件）
tracker.record() 消费输入型payload，解析出关键信息，构建内部`ToolCallEvent`
ToolCallEvent 是内部存储结构，存在 self._events[] 中，带游标，供 drain() 消费。

## 流式输出以及工具调用
1. 注册sink，建立流式通道
```python
        def tool_event_sink(event:  dict[str,Any]) -> None:
            """工具调用事件实时回调：直接入队推送给前端。"""
            enqueue(event)

        self._set_tool_event_sink(tool_event_sink)
```

`_set_tool_event_sink` 内部两件事：

将 `_tool_event_sink_enabled = True`（让 _drain_tool_events 返回空列表，避免重复）
将 `tool_event_sink` 函数注入 `ToolCallTracker._event_sink`

```python
    def _set_tool_event_sink(self, sink: Callable[[dict[str,Any]], None]| None)->None:
        self._tool_event_sink_enabled = sink is not None
        self._tool_tracker.set_event_sink(sink)
```

2. LLM触发 NoteTool -> record() 被调用

worker线程内调用 `_execute_task(emit_stream=True)` ,进而调用`summarizer.stream_task_summary()`，LLM流式输出中包含`[TOOL_CALL:note:{...}]` 框架解析后执行 NoteTool.run() ,然后自动回调`tool_call_listener=tracker.record`
在`record()`中
```python
        # 流式模式： 立即通过 sink推送事件
        sink = self._event_sink
        if sink:
            sink(self._build_payload(event, step=None))
```
此时`_event_sink`已被注册，立即同步调用`tool_event_sink`,payload结构如下:
```python
{
    "type": "tool_call",
    "event_id": 1,
    "agent": "任务总结专家",
    "tool": "note",
    "parameters": {"action": "create", "task_id": 1, ...},
    "result": "✅ 笔记创建成功\nID: note_xxx",
    "task_id": 1,
    "note_id": "note_xxx",
    "note_path": "/workspace/note/note_xxx.md"
}
```

3. `tool_event_sink` -> `enqueue()` -> `event_queue`

`tool_event_sink`直接调用`enqueue(event)`
```python
        def enqueue(event, *, task=None, step_override=None) -> None:
            payload = dict(event)
            target_task_id = payload.get("task_id")
            # 自动附加 stream_token（前端用于区分任务流）
            channel = channel_map.get(target_task_id) if target_task_id is not None else None
            if channel:
                payload.setdefault("step", channel["step"])
                payload["stream_token"] = channel["token"]   # e.g. "task_1"
            event_queue.put(payload)
```
`enqueue` 做了两件额外的事：

从 `channel_map` 查出该 `task` 的 `step` 编号和 `stream_token`（如 "task_1"），附加到 `payload`
将完整 `payload` 写入 `event_queue（线程安全的` queue.Queue）
此时 `worker` 线程的工作结束，控制权回到主线程。

4. `run_stream`主线程消费队列 -> `yield`
主线程始终在循环等待队列：
```python
            while finished_workers < active_workers:
                event = event_queue.get()          # 阻塞等待
                if event.get("type") == "__task_done__":
                    finished_workers += 1
                    continue
                yield event                        # ← tool_call 事件从这里 yield 出去
```
event_queue.get() 取到 tool_call 事件后，直接 yield event，此时 run_stream() 作为 Python generator 将控制权交出。

5. event_iterator() SSE 序列化 → StreamingResponse
FastAPI 路由层把 generator 包装成 SSE 格式：
```python
        def event_iterator() -> Iterator[str]:
            for event in agent.run_stream(payload.topic):
                yield f"data: {json.dumps(event, ensure_ascii=False)}\n\n"

        return StreamingResponse(
            event_iterator(),
            media_type="text/event-stream",
            headers={"Cache-Control": "no-cache", "Connection": "keep-alive"},
        )
```
每次 run_stream yield 一个事件，event_iterator 立即序列化为 SSE 帧：
```txt
data: {"type":"tool_call","event_id":1,"agent":"任务总结专家","tool":"note","task_id":1,"note_id":"note_xxx","stream_token":"task_1",...}\n\n
```
StreamingResponse 使用 HTTP chunked transfer encoding，每 yield 一帧立刻刷到网络，无需等待整个响应完成。

6. 阶段 6：前端 SSE 接收
前端 api.ts 用 fetch + ReadableStream 读取：
```txt
reader.read() 循环
→ buffer 拼接，按 "\n\n" 切割出完整帧
→ JSON.parse(dataPayload)
→ onEvent(event)
→ App.vue 根据 type="tool_call" 展示工具调用记录
```

流结束时清理
所有任务完成后 finally 块取消注册 sink：
```python
        finally:
            self._set_tool_event_sink(None)   # ← 取消 sink，退出流式模式
            for thread in threads:
                thread.join()
```