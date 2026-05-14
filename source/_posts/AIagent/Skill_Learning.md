---
title: Skill_Learning
date: 2026-05-14
categories: 
- AI
tag:
- AI
---

<!-- toc -->

[TOC]

# Deep Agents 工具与 Skill 加载学习指南

> 面向初学者，围绕 `execute`（ShellTool）、`read_file`（FileReadTool）、Skill 加载时机与动态加载机制，理解 Deep Agents 的核心实现。

---

## 1. 先建立整体心智模型

Deep Agents 不是把所有能力都写在一个 Agent 类里，而是拆成三层：

```text
create_deep_agent()
  -> 组装 middleware
  -> middleware 注册 tools / 修改 system prompt / 拦截 tool result
  -> backend 负责真正读文件、写文件、执行 shell
```

你可以先记住一句话：

> Tool 是给 LLM 看的函数接口，Middleware 负责把 Tool 接进 Agent，Backend 负责真正干活。

对应源码：

| 概念 | 关键文件 | 作用 |
|---|---|---|
| Agent 总装 | `libs/deepagents/deepagents/graph.py` | `create_deep_agent()` 组装所有 middleware |
| 文件/Shell 工具 | `libs/deepagents/deepagents/middleware/filesystem.py` | 创建 `read_file`、`execute` 等工具 |
| Backend 协议 | `libs/deepagents/deepagents/backends/protocol.py` | 定义后端必须实现哪些方法 |
| 本地文件后端 | `libs/deepagents/deepagents/backends/filesystem.py` | 直接读写真实磁盘文件 |
| 本地 Shell 后端 | `libs/deepagents/deepagents/backends/local_shell.py` | 用 `subprocess.run()` 执行 shell |
| Skill 中间件 | `libs/deepagents/deepagents/middleware/skills.py` | 扫描 `SKILL.md`，把 skill 列表注入 prompt |
| CLI 装配 | `libs/cli/deepagents_cli/agent.py` | CLI 下启用 memory、skills、shell、backend |

---

## 2. `ShellTool` 是怎么做的？

严格说，这个项目里核心工具不叫 `ShellTool`，而叫 `execute` tool。

### 2.1 创建工具的位置

文件：

```text
libs/deepagents/deepagents/middleware/filesystem.py
```

方法：

```python
def _create_execute_tool(self) -> BaseTool:
    ...
    return StructuredTool.from_function(
        name="execute",
        description=tool_description,
        func=sync_execute,
        coroutine=async_execute,
    )
```

这说明 `execute` 是通过 LangChain 的 `StructuredTool.from_function()` 包装出来的。

LLM 看到的是工具 schema：

```text
execute(command: str, timeout: int | None)
```

LLM 不直接执行 shell，它只是发起一次工具调用。

### 2.2 工具调用链路

```text
LLM 调用 execute(command="npm test")
  -> FilesystemMiddleware._create_execute_tool().sync_execute()
  -> resolved_backend = self._get_backend(runtime)
  -> 判断 backend 是否支持执行
  -> backend.execute(command, timeout=...)
  -> 返回 stdout / stderr / exit_code
```

关键代码点：

```python
if not _supports_execution(resolved_backend):
    return "Error: Execution not available..."

executable = cast("SandboxBackendProtocol", resolved_backend)
result = executable.execute(command, timeout=timeout)
```

### 2.3 真正执行 shell 的地方

CLI 本地模式会创建 `LocalShellBackend`。

文件：

```text
libs/deepagents/deepagents/backends/local_shell.py
```

核心方法：

```python
def execute(self, command: str, *, timeout: int | None = None) -> ExecuteResponse:
    result = subprocess.run(
        command,
        check=False,
        shell=True,
        capture_output=True,
        text=True,
        timeout=effective_timeout,
        env=self._env,
        cwd=str(self.cwd),
    )
```

也就是说，本地 shell 的本质就是：

```text
execute tool -> LocalShellBackend.execute() -> subprocess.run(..., shell=True)
```

### 2.4 为什么不是所有 Agent 都能用 shell？

因为 `execute` 只在 backend 支持 `SandboxBackendProtocol` 时才真正可用。

判断函数：

```python
def _supports_execution(backend: BackendProtocol) -> bool:
    if isinstance(backend, CompositeBackend):
        return isinstance(backend.default, SandboxBackendProtocol)
    return isinstance(backend, SandboxBackendProtocol)
```

每次模型调用前，`FilesystemMiddleware.wrap_model_call()` 会检查 backend：

```python
if not backend_supports_execution:
    filtered_tools = [
        tool for tool in request.tools
        if tool.name != "execute"
    ]
    request = request.override(tools=filtered_tools)
```

所以：

```text
backend 不支持 shell -> execute 工具不会暴露给 LLM
backend 支持 shell -> execute 工具出现在工具列表里
```

### 2.5 CLI 里什么时候启用 shell？

文件：

```text
libs/cli/deepagents_cli/agent.py
```

关键逻辑：

```python
if sandbox is None:
    if enable_shell:
        backend = LocalShellBackend(...)
    else:
        backend = FilesystemBackend(...)
else:
    backend = sandbox
```

含义：

| 模式 | backend | 是否有 shell |
|---|---|---|
| 本地 + `enable_shell=True` | `LocalShellBackend` | 有 |
| 本地 + `enable_shell=False` | `FilesystemBackend` | 无 |
| 远程 sandbox | sandbox backend | 取决于 sandbox 是否实现执行协议 |

### 2.6 初学者要注意的安全点

`LocalShellBackend` 是直接在你的机器上执行命令，不是真沙箱。

它使用：

```python
shell=True
```

因此命令可以：

- 读写本机文件
- 删除文件
- 访问网络
- 安装依赖
- 执行任意脚本

所以 CLI 里通常还会配合 Human-in-the-Loop 审批机制，避免危险命令直接执行。

---

## 3. `FileReadTool` 是怎么做的？

核心工具名是 `read_file`。

### 3.1 创建工具的位置

文件：

```text
libs/deepagents/deepagents/middleware/filesystem.py
```

方法：

```python
def _create_read_file_tool(self) -> BaseTool:
    ...
    return StructuredTool.from_function(
        name="read_file",
        description=tool_description,
        func=sync_read_file,
        coroutine=async_read_file,
    )
```

LLM 看到的是：

```text
read_file(file_path: str, offset: int = 0, limit: int = 100)
```

### 3.2 `read_file` 的执行流程

```text
LLM 调用 read_file(file_path="/app/main.py", offset=0, limit=100)
  -> validate_path(file_path)
  -> 判断是不是图片
  -> 如果是图片：download_files + base64 image block
  -> 如果是文本：backend.read(path, offset, limit)
  -> 如果结果太大：截断并提示
  -> 返回内容
```

核心代码结构：

```python
def sync_read_file(file_path, runtime, offset=0, limit=100):
    resolved_backend = self._get_backend(runtime)
    validated_path = validate_path(file_path)

    ext = Path(validated_path).suffix.lower()
    if ext in IMAGE_EXTENSIONS:
        responses = resolved_backend.download_files([validated_path])
        ...

    result = resolved_backend.read(validated_path, offset=offset, limit=limit)
    ...
    return result
```

### 3.3 为什么要有 `offset` 和 `limit`？

因为 Agent 不能随便把一个几千行文件全部塞进上下文。

默认分页策略是：

```text
第一次：read_file(path, limit=100)
第二次：read_file(path, offset=100, limit=200)
第三次：read_file(path, offset=300, limit=200)
```

这样做的好处：

- 控制 token 成本
- 避免上下文爆炸
- 鼓励 Agent 先看结构，再精准读取

### 3.4 真正读文件的是 Backend

`read_file` 工具自己不关心文件在哪里，它只调用：

```python
resolved_backend.read(validated_path, offset=offset, limit=limit)
```

不同 backend 有不同实现。

#### StateBackend

文件：

```text
libs/deepagents/deepagents/backends/state.py
```

核心：

```python
files = self.runtime.state.get("files", {})
file_data = files.get(file_path)
return format_read_response(file_data, offset, limit)
```

特点：

- 文件存在 LangGraph state 里
- 适合测试、临时运行
- 不直接碰真实磁盘

#### FilesystemBackend

文件：

```text
libs/deepagents/deepagents/backends/filesystem.py
```

特点：

- 文件在真实磁盘上
- `root_dir` 是工作目录
- `virtual_mode=True` 时会限制路径穿越

#### CompositeBackend

文件：

```text
libs/deepagents/deepagents/backends/composite.py
```

它负责按路径路由：

```text
/large_tool_results/... -> large_results_backend
/conversation_history/... -> conversation_history_backend
其他路径 -> default backend
```

所以 `read_file("/large_tool_results/xxx")` 可能读的是临时目录，而不是项目目录。

---

## 4. Tool 是什么时候注册进 Agent 的？

总入口：

```text
libs/deepagents/deepagents/graph.py
```

核心函数：

```python
create_deep_agent(...)
```

主 Agent middleware 栈里会加入：

```python
FilesystemMiddleware(backend=backend)
```

`FilesystemMiddleware.__init__()` 中预创建工具：

```python
self.tools = [
    self._create_ls_tool(),
    self._create_read_file_tool(),
    self._create_write_file_tool(),
    self._create_edit_file_tool(),
    self._create_glob_tool(),
    self._create_grep_tool(),
    self._create_execute_tool(),
]
```

注意：`execute` 会先被创建，但是否真正暴露给模型，要看 `wrap_model_call()` 里 backend 是否支持执行。

---

## 5. Skill 是什么？

Skill 是一个目录，里面必须有 `SKILL.md`。

典型结构：

```text
skills/
└── web-research/
    ├── SKILL.md
    └── helper.py
```

`SKILL.md` 顶部是 YAML frontmatter：

```markdown
---
name: web-research
description: Structured approach to conducting thorough web research
---

# Web Research Skill

这里写具体步骤、最佳实践、示例和注意事项。
```

核心目的：

```text
让 Agent 拥有大量领域工作流，但不一次性把所有内容放入上下文。
```

---

## 6. Skill 什么时机加载？

Skill 有两个加载阶段。

### 阶段一：Agent 运行前加载元数据

文件：

```text
libs/deepagents/deepagents/middleware/skills.py
```

方法：

```python
def before_agent(...):
    if "skills_metadata" in state:
        return None

    backend = self._get_backend(...)
    all_skills = {}

    for source_path in self.sources:
        source_skills = _list_skills(backend, source_path)
        for skill in source_skills:
            all_skills[skill["name"]] = skill

    return SkillsStateUpdate(skills_metadata=list(all_skills.values()))
```

关键点：

- 这个阶段只读取 `SKILL.md` 的 YAML frontmatter。
- 只保存 `name`、`description`、`path` 等元数据。
- 如果 state 里已经有 `skills_metadata`，不会重复加载。
- 多个 sources 按顺序加载，后面的同名 skill 覆盖前面的。

### 阶段二：每次模型调用前注入 skill 列表

方法：

```python
def modify_request(self, request):
    skills_metadata = request.state.get("skills_metadata", [])
    skills_list = self._format_skills_list(skills_metadata)
    skills_section = self.system_prompt_template.format(...)
    new_system_message = append_to_system_message(request.system_message, skills_section)
    return request.override(system_message=new_system_message)
```

注入给模型的是类似这样的列表：

```text
Available Skills:

- web-research: Structured approach to conducting thorough web research
  -> Read `/skills/web-research/SKILL.md` for full instructions
```

注意：这时还没有把完整 `SKILL.md` 塞进 prompt。

---

## 7. Skill 的动态加载是怎么实现的？

动态加载的本质不是 Python 自动 import，也不是框架自动展开全文。

它是靠 prompt 协议实现的：

```text
1. 系统提示告诉 LLM：你有这些 skills
2. 每个 skill 只展示 name、description、path
3. 当你判断需要某个 skill 时，自己调用 read_file 读取 SKILL.md
4. read_file 返回全文后，Skill 内容进入对话历史
5. LLM 按照 Skill 指南执行任务
```

系统提示模板在：

```text
libs/deepagents/deepagents/middleware/skills.py
```

模板叫：

```python
SKILLS_SYSTEM_PROMPT
```

里面明确写了：

```text
How to Use Skills (Progressive Disclosure):

1. Recognize when a skill applies
2. Read the skill's full instructions
3. Follow the skill's instructions
4. Access supporting files
```

所以动态加载链路是：

```text
用户请求
  -> LLM 看到 skill 列表
  -> LLM 判断某 skill 适用
  -> LLM 调用 read_file(skill_path)
  -> FilesystemMiddleware 执行 read_file
  -> Backend 读取 SKILL.md
  -> SKILL.md 全文进入上下文
  -> LLM 按 skill 工作流继续执行
```

这就是所谓的 Progressive Disclosure。

---

## 8. CLI 里 Skill 来源从哪里来？

文件：

```text
libs/cli/deepagents_cli/agent.py
```

当 `enable_skills=True` 时，会组装 sources：

```python
sources = [str(settings.get_built_in_skills_dir())]
sources.extend([str(skills_dir), str(user_agent_skills_dir)])
if project_skills_dir:
    sources.append(str(project_skills_dir))
if project_agent_skills_dir:
    sources.append(str(project_agent_skills_dir))
```

优先级从低到高：

```text
built-in skills
-> user .deepagents skills
-> user .agents skills
-> project .deepagents skills
-> project .agents skills
```

后面的 source 如果有同名 skill，会覆盖前面的。

这就是“用户技能覆盖内置技能”“项目技能覆盖用户技能”的机制。

---

## 9. 一张完整调用链图

```text
启动 CLI
  -> create_cli_agent()
    -> 准备 skills sources
    -> 创建 backend
    -> create_deep_agent()
      -> TodoListMiddleware
      -> MemoryMiddleware
      -> SkillsMiddleware
      -> FilesystemMiddleware
      -> SubAgentMiddleware
      -> SummarizationMiddleware

Agent 开始运行
  -> SkillsMiddleware.before_agent()
    -> 扫描 sources
    -> 读取各 skill 的 SKILL.md frontmatter
    -> 写入 state.skills_metadata

每次调用 LLM 前
  -> SkillsMiddleware.wrap_model_call()
    -> 把 skill 列表注入 system prompt
  -> FilesystemMiddleware.wrap_model_call()
    -> 注入 read_file/write_file/execute 使用规范
    -> 根据 backend 能力决定是否暴露 execute

LLM 决定使用 skill
  -> 调用 read_file("/path/to/skill/SKILL.md")
  -> FilesystemMiddleware.read_file
  -> Backend.read
  -> 返回 SKILL.md 全文

LLM 决定执行 shell
  -> 调用 execute(command="...")
  -> FilesystemMiddleware.execute
  -> Backend.execute
  -> LocalShellBackend / SandboxBackend 执行命令
```

---

## 10. 初学者推荐阅读顺序

不要一上来读所有文件。按这个顺序：

### 第 1 步：看总入口

```text
libs/deepagents/deepagents/graph.py
```

重点看：

```python
create_deep_agent()
```

目标：

- 明白 middleware 是按什么顺序组装的。
- 明白 `skills`、`memory`、`backend` 参数怎么传进去。

### 第 2 步：看文件工具

```text
libs/deepagents/deepagents/middleware/filesystem.py
```

重点看：

```python
FilesystemMiddleware.__init__()
_create_read_file_tool()
_create_execute_tool()
wrap_model_call()
```

目标：

- 明白工具是怎么通过 `StructuredTool.from_function()` 创建的。
- 明白 `execute` 为什么要根据 backend 能力动态启用。

### 第 3 步：看 backend

```text
libs/deepagents/deepagents/backends/protocol.py
libs/deepagents/deepagents/backends/filesystem.py
libs/deepagents/deepagents/backends/local_shell.py
libs/deepagents/deepagents/backends/state.py
```

目标：

- 明白 Tool 不直接操作文件。
- 明白 Backend 才是真正执行读写和 shell 的地方。

### 第 4 步：看 skill

```text
libs/deepagents/deepagents/middleware/skills.py
```

重点看：

```python
_list_skills()
_alist_skills()
SkillsMiddleware.before_agent()
SkillsMiddleware.modify_request()
SkillsMiddleware.wrap_model_call()
```

目标：

- 明白“启动前只加载 metadata”。
- 明白“全文靠 read_file 动态读取”。

### 第 5 步：看 CLI 装配

```text
libs/cli/deepagents_cli/agent.py
```

重点看：

```python
create_cli_agent()
```

目标：

- 明白 CLI 如何决定是否启用 shell。
- 明白 CLI 从哪些目录加载 skills。

---

## 11. 动手练习

### 练习 1：找到所有内置工具

在 `FilesystemMiddleware.__init__()` 里找到：

```python
self.tools = [...]
```

写下每个工具的名字：

```text
ls
read_file
write_file
edit_file
glob
grep
execute
```

问题：

- 哪些工具是读操作？
- 哪些工具是写操作？
- 哪个工具最危险？

参考答案：

```text
读操作：ls, read_file, glob, grep
写操作：write_file, edit_file
危险工具：execute
```

### 练习 2：追踪 `read_file`

从这里开始：

```python
_create_read_file_tool()
```

顺着找：

```text
sync_read_file()
  -> self._get_backend(runtime)
  -> validate_path(file_path)
  -> resolved_backend.read(...)
```

然后分别看：

```text
StateBackend.read()
FilesystemBackend.read()
CompositeBackend.read()
```

你要回答：

```text
同一个 read_file 工具，为什么可以读 state、磁盘、临时目录？
```

答案：

```text
因为 read_file 面向的是 BackendProtocol，不依赖具体后端实现。
```

### 练习 3：追踪 `execute`

从这里开始：

```python
_create_execute_tool()
```

顺着找：

```text
sync_execute()
  -> _supports_execution(backend)
  -> backend.execute(command)
  -> LocalShellBackend.execute()
  -> subprocess.run()
```

你要回答：

```text
为什么 StateBackend 不能执行 shell？
```

答案：

```text
因为 StateBackend 不实现 SandboxBackendProtocol，也没有 execute() 能力。
```

### 练习 4：做一个最小 Skill

创建目录：

```text
skills/my-debug-skill/
```

创建文件：

```text
skills/my-debug-skill/SKILL.md
```

内容：

```markdown
---
name: my-debug-skill
description: Use this skill when debugging Python errors, tracebacks, failing tests, or import issues.
---

# My Debug Skill

## When to Use

Use this when the user asks you to debug a Python problem.

## Workflow

1. Read the full traceback.
2. Locate the file and line number.
3. Read the relevant function.
4. Reproduce the error with the smallest command.
5. Patch the root cause.
6. Run the smallest useful verification.
```

然后观察：

- Agent 启动时只会看到 `name` 和 `description`。
- 当任务匹配 debugging 时，它应该用 `read_file` 读取完整 `SKILL.md`。

---

## 12. 常见误区

### 误区 1：Skill 会自动全部加载进 prompt

不会。

默认只加载元数据。完整内容要靠 LLM 调用 `read_file(SKILL.md)`。

### 误区 2：Tool 自己负责所有逻辑

不准确。

Tool 是接口层。真正读文件、写文件、执行命令的是 backend。

### 误区 3：LocalShellBackend 是安全沙箱

不是。

它直接在本机执行命令。安全边界主要靠用户审批、运行环境隔离和命令 allowlist。

### 误区 4：`execute` 一定会暴露给 LLM

不一定。

`FilesystemMiddleware.wrap_model_call()` 会根据 backend 能力过滤工具。

---

## 13. 最小源码阅读地图

```text
graph.py
  create_deep_agent()
    -> 添加 SkillsMiddleware
    -> 添加 FilesystemMiddleware

filesystem.py
  FilesystemMiddleware.__init__()
    -> 创建 read_file
    -> 创建 execute

  _create_read_file_tool()
    -> backend.read()

  _create_execute_tool()
    -> backend.execute()

  wrap_model_call()
    -> 过滤 execute
    -> 注入文件工具提示

skills.py
  before_agent()
    -> 扫描 skill 元数据

  modify_request()
    -> 注入 skill 列表

  wrap_model_call()
    -> 每次 LLM 调用前追加 skill section

local_shell.py
  LocalShellBackend.execute()
    -> subprocess.run()
```

---

## 14. 你最终应该能讲清楚的四句话

1. `read_file` 是 `FilesystemMiddleware` 创建的 LangChain tool，真正读取动作由 backend 的 `read()` 完成。
2. `execute` 是 shell 工具，只有 backend 实现 `SandboxBackendProtocol` 时才会暴露给模型，本地 CLI 下由 `LocalShellBackend` 用 `subprocess.run()` 执行。
3. Skill 在 Agent 运行前通过 `before_agent()` 加载 metadata，每次模型调用前只把 skill 列表注入 system prompt。
4. Skill 全文不是自动加载，而是模型根据描述判断需要后，调用 `read_file(SKILL.md)` 动态读取，这就是渐进式披露。

