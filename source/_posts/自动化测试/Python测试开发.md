---
title: Python测试开发       
date: 2025-04-01
updated: 2025-04-01
categories: 
- 自动化测试
tag:
- learning
---

<!-- toc -->

[TOC]

## 输入日期，判断这一天是这一年的第几天

```python
import datetime


def dayofyaer():
    year = input("请输入年份： ")
    month = input("请输入月份： ")
    day = input("请输入天： ")

    date_now = datetime.date(year=int(year), month=int(month), day=int(day))
    date_begin = datetime.date(year=int(year), month=1, day=1)
    return (date_now-date_begin).days +1

ret = dayofyaer()
print(ret)
```

## 打乱一个排好序的list对象alist

```python
import random

alist = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
random.shuffle(alist)
print(alist)
```

## 现有字典d = {'a':24,'g':52,'i':12,'k':33}按照value值进行排序

```python
d = {'a':24, 'g':52, 'i':13, 'k':33}
sorted_d = sorted(d.items(), key=lambda x:x[1])
print(d)
print(sorted_d)
```

```
x[0]代表用的key进行排序，x[1]代表用value进行排序
```

## 字典推导式

```python
pairs = [('a', 24), ('g', 52), ('i', 13), ('k', 33)]
d = {key: value for (key, value) in pairs}
print(d)  # 输出：{'a': 24, 'g': 52, 'i': 13, 'k': 33}
```

## 反转字符串"aStr"

```python
print("aStr"[::-1])
```

## Py中的切片（Slice）操作

**基本语法**

```python
sequence[start : end : step]
```

- **`start`**：起始索引（包含），默认为 `0`。
- **`end`**：结束索引（不包含），默认为序列长度。
- **`step`**：步长（可选），默认为 `1`。

在 `[:-1]` 中：

- **`start` 未指定** → 默认从 `0` 开始。
- **`end = -1`** → 选取到倒数第二个元素（因为 `end` 不包含）。
- **`step` 未指定** → 默认步长为 `1`。

|           |                  |                        |
| --------- | ---------------- | ---------------------- |
| 操作      | 含义             | 示例（`[1, 2, 3, 4]`） |
| [ : ]     | 复制整个序列     | [1, 2, 3, 4]           |
| [ : -1]   | 去掉最后一个元素 | [1, 2, 3]              |
| [ : : -1] | 反转序列         | [4, 3, 2, 1]           |

## **Python 切片的特点**

```python
list =['a', 'b', 'c', 'd', 'e']
print(list[10:])
```

代码将输出[],不会产生IndexExrror错误

当切片索引超出列表范围时，Python **不会抛出异常**，而是返回一个空列表或尽可能合法的子序列。

- **无运行时错误**：代码不会崩溃或报错，但可能隐藏潜在逻辑错误。
- **静默失败（Silent Failure）**：如果开发者误以为切片会返回有效数据，但实际上得到空列表，可能导致后续逻辑错误（如遍历空列表、数据丢失）
- Bug难以被追踪

## 将字符串"k:1|k1:2|k2:3|k3:4",处理成字典{k:1,k1:2}

```python
str1 = "k:1|k1:2|k2:3|k3:4"
dict1 = {}
for iterms in str1.split('|'):
    key,value = iterms.split(':')
    dict1[key] = value
print(dict1)

# 字典推导式
d = {k:int(v) for t in str1.split("|") for k,v in [t.split(":")]}
print(d)
```

## 请按alist中元素的age由大到小排序

```python
alist = [{'name':'a','age':20},{'name':'b','age':30},{'name':'c','age':22}]
def sort_by_age(list1):
    # reverse=False：升序排序（默认值，可省略）。
    # reverse=True：降序排序
    return sorted(alist,key=lambda x:x['age'],reverse=False)
sorted_alist = sort_by_age(alist)
print(sorted_alist)
```

## 列表表达式，产生一个公差为11的等差数列

```python
print([x*11 for x in range(10)])
```

## 给定两个列表，怎么找出他们相同的元素和不同的元素？

```python
list1 = [1, 2, 3]
list2 = [3, 4, 5]
set1 = set(list1)
set2 = set(list2)
print(set1 & set2)
print(set1 ^ set2)
```

## 写出一段python代码实现删除list里面的重复元素

```python
l1 = ['a', 'a', 'j', 'd', 'v', 'b', 'v']
l2 = list(set(l1))
print(l2)
```

用list类sort的方法

```python
l1 = ['a', 'a', 'j', 'd', 'v', 'b', 'v']
l2 = list(set(l1))
l2.sort(key=l1.index)
# l2 = sorted(set(l1), key=l1.index)
# l2 = list(dict.fromkeys(l1))
print(l2)
```

遍历

```python
l1 = ['a', 'a', 'j', 'd', 'v', 'b', 'v']
l2 = []
for i in l1:
    if not i in l2:
        l2.append(i)
print(l2)
```

## 给定两个listA，B，请用找出A，B中相同和不同的元素

```python
A,B中相同的元素：print(set(A) & set(B))
A,B中不同的元素：print(set(A) ^ set(B))
```

