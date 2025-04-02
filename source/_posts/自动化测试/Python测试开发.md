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
sorted(d.items())
```

