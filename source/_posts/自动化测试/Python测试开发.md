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

## 字符串的操作

实现一个方法 `get_missing_letter`，功能是：

1. 接收一个字符串参数
2. 返回将该字符串补全为全字母句（PANGRAM）所缺失的字母
   - 全字母句指包含所有26个英文字母的句子
   - 例如："A quick brown fox jumps over the lazy dog"

#### 具体要求

- 忽略输入字符串的大小写（统一视为小写）
- 返回结果应为小写字母
- 按字母顺序排序
- 忽略所有非ASCII字符（只处理字母）

#### 示例说明

1. 输入："A quick brown fox jumps over the lazy dog"
   输出：""
   （因为已包含所有字母）
2. 输入："A slow yellow fox crawls under the proactive dog"
   输出："bjkmqz"
   （缺失字母b、j、k、m、q、z）
3. 输入："Lions, and tigers, and bears, oh my!"
   输出："cfjkpquvwxz"
   （缺失多个字母）
4. 输入：""
   输出："abcdefghijklmnopqrstuvwxyz"
   （空字符串缺失全部字母）

```python
def get_missing_letter(a):
    # 创建包含所有字母的集合
    s1 = set("abcdefghijklmnopqrstuvwxyz")
    # 将输入字符串转为小写并去除非字母字符
    s2 = set(a.lower())
    ret = "".join(sorted(s1-s2))
    return ret

ret = get_missing_letter("guofujw")
print(ret)

# 其他方法生成字母
import string
# 方法1：使用string模块
letters1 = string.ascii_lowercase
print(letters1)

# 方法2：使用ord()/chr()函数
letters2 = "".join(map(chr,range(ord('a'),ord('z') +1)))
print(letters2)

```

```python
#（1）ord() 函数

- 功能：返回字符的Unicode码点（整数）

- 示例：
  ord('a')  # 返回 97
  ord('z')  # 返回 122


# （2）range() 函数

- 功能：生成整数序列
- 参数：
  - start=ord('a')（97）
  - stop=ord('z')+1（123，包含122）
- 实际生成序列： 97,98,99, ..., 122

#（3）map(chr, ...)

- 功能：将整数序列转换为字符序列

- 作用：

  chr(97) → 'a'
  chr(98) → 'b'
  ...
  chr(122) → 'z'


- 输出：生成器对象，包含字符 'a'到 'z'

# （4）"".join()

- 功能：将字符序列拼接成字符串
- 结果：'abcdefghijklmnopqrstuvwxyz'
```



## 可变类型和不可变类型

1. 可变类型有`list`，`dict`,不可变类型有`string`，`number`,`tuple`
2. 当进行修改操作时，可变类型传递的是内存中的地址，也就是说，直接修改内存中的值，并没有开辟新的内存。
3. 不可变类被更改时，并没有改变原内存地址中的值，而是开辟一块新的内存，将原地址中的值复制过去，对这块新开辟的内存中的值进行操作

## is和==的区别

#### 1. 核心区别

| 操作符 | 比较内容             | 调用方法   | 本质                 |
| :----- | :------------------- | :--------- | :------------------- |
| `is`   | 对象标识（内存地址） | 无         | 判断是否为同一个对象 |
| `==`   | 对象值/内容是否相等  | `__eq__()` | 判断逻辑意义上的相等 |

is：比较的是两个对象的id值是否相等，也就是比较两对象是否为同一实例对象，是否指向同一个内存地址

==：比较的是两个对象的内容/值是否相等，默认会调用对象的eq（）方法

## 使用一行python代码写出1+2+3+10248

```python
from functools import reduce
#1.使用sum内置求和函数
num = sum([1, 2, 3, 10248])
print(num)
#2.reduce函数
num1 = reduce(lambda x,y :x+y,[1, 2, 3, 10248])
print(num1)
```

## Python中变量的作用域？（变量查找顺序）

函数作用域的LEGB顺序

|            |              |                        |                  |
| ---------- | ------------ | ---------------------- | ---------------- |
| **作用域** | **英文全称** | **说明**               | **生命周期**     |
| Local      | 局部作用域   | 函数内部定义的变量     | 函数执行期间     |
| Enclosing  | 闭包作用域   | 嵌套函数的外层函数变量 | 外层函数执行期间 |
| Global     | 全局作用域   | 模块级别定义的变量     | 模块存活期间     |
| Built-in   | 内置作用域   | Python内置名称         | 解释器存活期间   |

## 字符串"123"转换成123，不使用内置api

方法一：利用`str`函数

```python
def atoi(s):
    num  = 0
    for v in s:
        for j in range(10):
            if v == str(j):
                num = num *10 +j
    return num
```

方法二：利用`ord`函数

```python
def atoi(s):
    num  = 0
    for v in s:
        num = num *10 + ord(v) - ord('0')
    return num
```

方法三：利用`eval`函数

```python
def atoi(s):
    num = 0                     # 初始化结果为0
    for v in s:                 # 遍历字符串每个字符
        t = "%s *1" % v         # 生成如"5 *1"的表达式字符串
        n = eval(t)             # 执行字符串表达式得到数字值
        num = num * 10 + n      # 十进制左移并累加
    return num                  # 返回最终结果
# 字符转数字技巧：
# eval("%s *1" % v) 等效于 int(v)，但：
# 
# 利用字符串拼接生成表达式
# 
# 通过eval执行数学运算
# 
# 实际上等同于 n = 1 * int(v)
```

方法四：结合方法二，使用`reduce`，一行解决

## 两数之和

```python
class Solution:
    def twoSum(self,nums,target):
        ret = {}
        tmp_num = nums[:]
        print(len(nums))
        for i in range(len(nums)):
            tmp = target - nums[i]
            if tmp in nums[i+1:]:
                # 从i+1开始查找，确保找到正确的配对索引
                return [i,nums.index(tmp,i+1)]
```

# 元类

## Python中类方法，类实例方法，静态方法有何区别

类方法：是类对象的方法，在定义时需要在上方使用@classmethod进行装饰，形参为cls，标识类对象，类对象和实例对象都可调用

类实例方法：是类实例化对象的方法，只有实例对象可以调用，形参为self，指代对象本身

静态方法：是一个任意函数，在其上方使用@staticmethod进行装饰，可以用对象直接调用，静态方法实际上跟该类没有太大关系

#### 1. 三种方法对比表

| 方法类型     | 装饰器          | 第一个参数 | 调用方式                 | 访问权限                       |             典型用途             |
| :----------- | :-------------- | :--------- | :----------------------- | :----------------------------- | :------------------------------: |
| **实例方法** | 无              | `self`     | 实例.方法()              | 可访问实例和类属性             |           对象行为操作           |
| **类方法**   | `@classmethod`  | `cls`      | 类.方法() 或 实例.方法() | 只能访问类属性                 |       工厂模式、类状态操作       |
| **静态方法** | `@staticmethod` | 无         | 类.方法() 或 实例.方法() | 不能访问实例或类属性（需传参） | 工具函数、与类逻辑相关的辅助功能 |

## 遍历一个object的所有属性，并print每一个属性名

```python
class Car:
    def __init__(self, name, loss):
        self.name = name
        self.loss = loss

    def getName(self):
        return self.name

    def getPrice(self):
        return self.loss[0]  # 返回loss列表第一个元素

    def getLoss(self):
        return self.loss[1] * self.loss[2]  # 计算后两个元素的乘积


# 实例化
Bmw = Car("奔驰", [114, 514, 19])

# 属性访问测试
print(getattr(Bmw, "name"))  # 输出: 奔驰
print(Bmw.getName())  # 输出: 奔驰
print(Bmw.getPrice())  # 输出: 114
print(Bmw.getLoss())  # 输出: 514*19=9766

# 查看对象成员
print(dir(Bmw))
# ['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', 'getLoss', 'getName', 'getPrice', 'loss', 'name']

```
