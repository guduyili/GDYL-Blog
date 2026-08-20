---
title: AITestHub_Learning
date: 2026-06-16
categories: 
- AI
tag:
- AI
---

<!-- toc -->

[TOC]

# 初步学习重点

```text
配置加载 -> LLM 初始化 -> 任务分析 -> 构造执行 Prompt -> 执行动作计划 -> 更新任务状态 -> 生成 history
```

# browser-use补丁对照



```python
#1. LLM 可能返回 action 数组外的字段，严格 schema 会直接校验失败
# ActionModel.model_config → extra='allow'
	def _patch_action_model(self) -> None:
        try:
            from browser_use.tools.registry.views import ActionModel
            from pydantic import ConfigDict
        except Exception:
            return
        ActionModel.model_config = ConfigDict(arbitrary_types_allowed=True, extra="allow")
        
        
#2. ToolRegistry.execute_action 补丁
# LLM常输出 switch_tab/整数index/非dict参数,需归一化为browser-use schema
	def _patch_tool_registry(self) -> None:
        try:
            from browser_use.tools.registry.service import Registry as ToolRegistry
        except Exception:
            return

        if getattr(ToolRegistry.execute_action, "_testhub_learning_patched", False):
            return

        original_execute_action = ToolRegistry.execute_action

        async def patched_execute_action(self, action_name: str, params: dict, **kwargs):
            if action_name == "switch_tab":
                action_name = "switch"

            if isinstance(params, int):
                params = normalize_action_params(action_name, params)
            elif params is not None and not isinstance(params, dict):
                if action_name in {"switch", "switch_tab"}:
                    params = {"tab_id": params}
                else:
                    params = {"value": params}
            elif isinstance(params, dict):
                params = normalize_action_params(action_name, params)

            return await original_execute_action(self, action_name, params, **kwargs)

        setattr(patched_execute_action, "_testhub_learning_patched", True)
        ToolRegistry.execute_action = patched_execute_action

#3. BrowserSession.connect 补丁
# Windows/Linux 下 CDP 端口未就绪时连接失败；需轮询 http://localhost:{port}/json/version
    def _patch_browser_session_connect(self) -> None:
        try:
            import httpx
            from browser_use.browser.session import BrowserSession
        except Exception:
            return

        if getattr(BrowserSession.connect, "_testhub_learning_patched", False):
            return

        original_connect = BrowserSession.connect

        async def patched_connect(self, cdp_url: Optional[str] = None):
            browser_profile = getattr(self, "browser_profile", None)
            effective_cdp_url = cdp_url or getattr(browser_profile, "cdp_url", None)

            if effective_cdp_url:
                return await original_connect(self, cdp_url=effective_cdp_url)

            port = getattr(browser_profile, "remote_debugging_port", None)
            if port is None and browser_profile is not None:
                args = list(getattr(browser_profile, "args", []) or [])
                args.extend(list(getattr(browser_profile, "extra_chromium_args", []) or []))
                for arg in args:
                    text = str(arg)
                    if text.startswith("--remote-debugging-port="):
                        try:
                            port = int(text.split("=", 1)[1])
                            break
                        except ValueError:
                            pass
                        
#4. LocalBrowserWatchdog._find_free_port
    def _patch_local_browser_port(self) -> None:
        try:
            from browser_use.browser.watchdogs.local_browser_watchdog import LocalBrowserWatchdog
        except Exception:
            return

        if getattr(LocalBrowserWatchdog._find_free_port, "_testhub_learning_patched", False):
            return

        original_find_free_port = LocalBrowserWatchdog._find_free_port

        def patched_find_free_port(*args, **kwargs):
            if ensure_supported_browser_platform() == "Linux":
                return 9222
            try:
                return original_find_free_port(*args, **kwargs)
            except TypeError:
                return original_find_free_port()

        setattr(patched_find_free_port, "_testhub_learning_patched", True)
        LocalBrowserWatchdog._find_free_port = staticmethod(patched_find_free_port)

        
#5.
```

