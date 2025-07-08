---
title: Xmind自动化项目   
date: 2025-06-23
categories: 
- 自动化测试
tag:
- learning
---
<!-- toc -->

[TOC]



## xtodict详解

def xtodict(xdata, escape=False, alt_list=False):
    mkey = xdata['title']
    res = {mkey: {}}
    res_var = {}

```python
def xtodict(xdata, escape=False, alt_list=False):
    mkey = xdata['title']
    res = {mkey: {}}
    res_var = {}

    def xupdate(key, data_x, result: dict):
        if 'topics' in data_x:
            for i in data_x['topics']:
                if 'makers' in i:
                    if 'flag-gray' in i['makers'] or 'flag-dark-gray' in i['makers']:
                        continue                     # 忽略灰色/暗灰色节点
                if 'topics' in i:                  # 有子节点
                    if not alt_list:
                        result[key].update({i['title']: {}})
                        xupdate(i['title'], i, result[key])
                    else:                          # alt_list=True 时子节点当成列表
                        result[key].update({i['title']: []})
                        if 'topics' in i:
                            for ii in i['topics']:
                                result[key][i['title']].append(ii['title'])
                else:                              # 叶子节点
                    if escape:                     # escape=True 时只记录 {父节点: 值}
                        res_var.update({key: i['title']})
                        continue
                    result.update({key: i['title']})
    xupdate(mkey, xdata, res)
    if escape:
        return res_var
    return res
```

1. 传入的 `xdata` 是 `xmindparser` 解析后的字典，`xdata['title']` 为当前节点标题。
2. 函数初始化两个字典：`res` 保存最终的嵌套结构；`res_var` 用于 `escape=True` 时专门收集叶子节点信息。
3. 内部定义递归函数 `xupdate`，逐层遍历 `topics`（子节点）：
   - 遇到带 `flag-gray` 或 `flag-dark-gray` 标记的节点会被跳过。
   - 对于有子节点的情况：
     - `alt_list=False`（默认）时，创建嵌套字典 `{子节点标题: {}}` 并继续递归。
     - `alt_list=True` 时，子节点保存为列表形式 `{子节点标题: [孙节点标题1, ...]}`，常用于处理 “端口映射” 等一对多配置。
   - 对于叶子节点：
     - `escape=True` 时返回 `{父节点标题: 叶子标题}` 的映射，常用于获取 `VARS` 中的变量值。
     - 否则直接记录 `{父节点标题: 叶子标题}` 到结果字典。
4. 递归遍历完成后，根据 `escape` 参数返回 `res_var` 或 `res`。

函数返回值因此可能是层层嵌套的字典，也可能是简化的 `{key: value}` 映射，取决于 `escape` 和 `alt_list` 参数。

## xtodict_li详解

```python
def xtodict_li(xdata, wlist=False):
    res = []
    def xupdate(key, data_x, result: list or dict):
        if 'topics' in data_x:
            idx = 0
            for i in data_x['topics']:
                if 'makers' in i:
                    if 'flag-gray' in i['makers'] or 'flag-dark-gray' in i['makers']:
                        continue
                    if wlist and 'task-done' not in i['makers']:
                        continue                    # 仅保留 task-done 的节点
                elif wlist:
                    continue
                if 'topics' in i:                   # 有子节点
                    if isinstance(result, list):
                        result.append({i['title']: []})
                        xupdate(i['title'], i, result[idx])
                        idx += 1
                    elif isinstance(result, dict):
                        result.update({i['title']: []})
                        xupdate(i['title'], i, result[key])
                else:                               # 叶子节点
                    if key is not None:
                        result[key].append(i['title'])
                    else:
                        result.append(i['title'])
    xupdate(None, xdata, res)
    return res
```

1. `res` 初始化为空列表；与 `xtodict` 不同，它最终生成以列表为主体的结构。

2. `xupdate` 同样递归遍历 `topics`：

   - 对节点的灰色标记进行过滤。
   - `wlist=True` 时，只保留带有 `task-done` 标签的节点，否则略过。

3. 根据当前 `result` 的类型处理：

   - 如果 `result` 是列表，在其中加入 `{节点标题: []}` 字典，并递归填充其子节点（保持顺序），随后 `idx += 1`。
   - 如果 `result` 是字典，更新 `{节点标题: []}` 并递归处理。
   - 对叶子节点，则将标题追加进当前列表。

4. 顶层调用 `xupdate(None, xdata, res)`，最终得到的 `res` 可能形如：

   ```python
   [{'场景A': ['用例1', '用例2']}, {'场景B': ['用例3']}]
   ```

   其中顺序与 XMind 中的节点顺序一致。

该函数主要在解析 “场景” 或 “标签” 配置等需要保留顺序的地方使用，`wlist=True` 则仅统计已完成的（打勾的）条目。
