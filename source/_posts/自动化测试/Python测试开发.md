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

## python如何实现单例模式，请写出两种实现方式

### **参数说明**

#### 1. `*args`

- **含义**：接收任意数量的**位置参数**（Positional Arguments）。

- **作用**：在实例化类时，传递构造函数的非关键字参数（如 `MyClass(1, 2, name="test")` 中的 `1` 和 `2`）。

- **示例**：

  python

  复制

  ```
  a = MyClass(10, 20)  # args = (10, 20)
  ```

#### 2. `**kwargs`

- **含义**：接收任意数量的**关键字参数**（Keyword Arguments）。

- **作用**：在实例化类时，传递构造函数的命名参数（如 `MyClass(name="Alice", age=25)` 中的 `name` 和 `age`）。

- **示例**：

  python

  复制

  ```
  b = MyClass(name="Bob", role="admin")  # kwargs = {"name": "Bob", "role": "admin"}
  ```



**使用装饰器**

```python
def singleton(cls):
    instances = {}
    def get_instance(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]
    return get_instance

@singleton
class MyClass:
    def __int__(self):
        print("MyClass 实例已创建")

a = MyClass()
b = MyClass()
print(a is b) # 输出 True（a 和 b 是同一个实例）
```

**重写基类的 __new__ 方法**

```python
class SingletonClass:
    _instance = None # 类变量保存唯一实例

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            # 调用父类 __new__ 创建实例
            cls._instance = super().__new__(cls)
        return cls._instance
    def __int__(self):
        print("SingletonClass 实例已创建")
# 测试
x = SingletonClass()  # 输出 "SingletonClass 实例已创建"
y = SingletonClass()
print(x is y)         # 输出 True（x 和 y 是同一个实例）
```

**元类**，元类是用于创建类对象的类，类对象创建实例对象的时一定要调用call方法，因此再调用call时候保证始终只创建一个实例既可，type

```python
# SingletonMeta 元类
# 
# 继承自 type，通过 __call__ 拦截类的实例化过程（即 MyClass() 的调用）。
# 
# _instances 字典保存每个类的唯一实例。
# 
# __call__ 方法的作用
# 
# 当调用 MyClass() 时，实际触发的是 SingletonMeta.__call__。
# 
# 检查是否已有实例：
# 
# 若无，调用父类 type.__call__ 创建实例并保存。
# 
# 若有，直接返回现有实例。
class SingletonMeta(type):
    """
    单例元类，通过 __call__ 控制实例化逻辑
    """
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]

class MyClass(metaclass=SingletonMeta):
    def __init__(self, name):
        self.name = name
        print(f"初始化 MyClass，name={name}")

# 测试
a = MyClass("实例A")  # 输出：初始化 MyClass，name=实例A
b = MyClass("实例B")  # 无输出（实例已存在）
print(a is b)       # 输出：True
print(a.name)       # 输出：实例A（注意：b.name 也是 "实例A"！）
```

## 反转一个整数，例如-123 --> -321

```python
class Solution(object):
    def reverse(self,x):
        if -10 < x < 10:
            return x
        str_x = str(x)
        if str_x[0] != '-':
            return int(str_x[::-1])
        else:
            str_x = str_x[1:][::-1]
            x = int(str_x)
            x = -x
        return x if -2147483648<x<2147483648 else 0

num = int(input())
ret = Solution().reverse(num)
print(ret)
```

## 设计实现遍历目录与子目录，抓取.py文件

```python
import os

def get_files(dir, suffix):
    res = []  # 存储结果列表
    for root, dirs, files in os.walk(dir):  # 遍历目录树
        for filename in files:  # 检查每个文件
            name, ext = os.path.splitext(filename)  # 分离文件名和扩展名
            if ext == f'.{suffix}':  # 判断扩展名是否匹配
                res.append(os.path.join(root, filename))  # 拼接完整路径

    print(res)  # 打印结果


get_files("./", 'py')  # 调用示例：查找当前目录所有.py文件
```

## Python遍历列表是删除元素的正确做法

复制做法

```python
a = [1, 2, 3, 4, 5, 7, 89, 56, 23]
print(id(a))
print(id(a[:]))
for i in a[:]:
    if i > 5:
        pass
    else:
        a.remove(i)
    print(a)
print('--------------')
print(id(a))
```

倒序删除

因为列表总是"向前移"，所以可以倒序遍历，即使后面的元素被修改了，还没有被遍历的元素和其坐标还是保持不变的

倒序删除时，被删除元素**之后**（在内存中其实是"之前"）的索引都不会改变，因为处理顺序和删除方向一致。

```python
a = [1, 2, 3, 4, 5, 7, 89, 56, 23]
print(id(a))
for i in range(len(a)-1,-1,-1):
    if a[i] > 5:
        pass
    else:
        a.remove(a[i])
print(id(a))
print('--------------')
print(a)
```

