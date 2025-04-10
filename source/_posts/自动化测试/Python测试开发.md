---
title: Python测试开发       
date: 2025-04-01
updated: 2025-04-08
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

## 统计一个文本中单词频次最高的10个单词

```python
def test(filepath):
    distone = {}

    with open(filepath,'r',encoding='utf-8') as f:
        for line in f:
            line  = re.sub("\w", " ", line)
            lineone = line.split()
            for keyone in lineone:
                if not distone.get(keyone):
                    distone[keyone] = 1
                else:
                    distone[keyone] += 1
    num_ten = sorted(distone.items(),key=lambda x:x[1], reverse=True)[:10]
    num_ten = [x[0] for x in num_ten]
    return num_ten

def test2(filepath):
    with open(filepath) as f:
        return list(map(lambda c:c[0], Counter(re.sub("\w+", " ", f.read()).split()).most_common(10)))
    
```

## 偶数和index偶数

1. 该元素是偶数

2. 该元素在原list中是在偶数的位置（index是偶数）

```python


def num_list(num):
    return [i for i in num if i% 2 ==0 and num.index(i) % 2 ==0]
num = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
ret = num_list(num)
print(ret)
```

## 使用单一的列表生成式来产生一个新的列表

```python
list_data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
ret = [x for x in list_data[::2] if x%2 == 0]
print(ret)
print(list_data)
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

## 实现支持多操作符的类

```python
class Array:
    def __init__(self, data=None):
        self.__list = list(data) if data else {}
        print("constructor")

    def __del__(self):
        print("destructor")

    def __str__(self):
        return f"Array({self.__list}"

    #容器协议
    def __setitem__(self, key, value):
        self.__list[key] = value

    def __len__(self):
        return len(self.__list)

    def __contains__(self, item):
        return item in self.__list

    # 算术运算符
    def __add__(self, other):
        return Array(self.__list + list(other))

    def __mul__(self, n):
        return Array(self.__list * n)

    #比较运算符
    def __eq__(self, other):
        return Array(self.__list == list(other))

    #迭代协议
    def __iter__(self):
        return iter(self.__list)

    #自定义方法
    def append(self, vaule):
        self.__list.append(vaule)

    def append(self, index):
        del self.__list[index]

    def DisplayItems(self):
        print ("show all items---")
        for item in self.__list:
            print(item)
        
```

| **类型**   | **方法**             | **操作符/行为**          |
| :--------- | :------------------- | :----------------------- |
| 初始化     | `__init__`           | `arr = Array([1,2])`     |
| 字符串表示 | `__str__`            | `print(arr)`             |
| 索引访问   | `__getitem__`        | `arr[0]`                 |
| 长度查询   | `__len__`            | `len(arr)`               |
| 算术运算   | `__add__`, `__mul__` | `arr1 + arr2`, `arr * 3` |
| 比较       | `__eq__`             | `arr1 == arr2`           |
| 迭代       | `__iter__`           | `for x in arr:`          |

## Cython/PyPy/CPython/Numba 的缺点

| **工具**    | **用途**          | **主要缺点**                                                 |
| :---------- | :---------------- | :----------------------------------------------------------- |
| **CPython** | 官方Python解释器  | 执行速度慢，全局解释器锁（GIL）限制多线程性能                |
| **Cython**  | Python转C编译器   | 需要学习额外语法（如类型注解），调试复杂，不适合纯Python动态特性 |
| **PyPy**    | JIT加速解释器     | 内存占用高，对C扩展兼容性差，启动时间慢                      |
| **Numba**   | 数值计算JIT编译器 | 仅支持NumPy和有限Python特性，首次运行编译耗时，不适合通用代码 |

# 内存管理与垃圾回收机制

## 哪些操作会导致Python内存溢出，怎么处理？

- 导致内存溢出的操作
  - 处理超大文件（如一次性读取整个大文件到内存）。
  - 无限循环创建对象（如在循环中不断生成大量对象且不释放）。
  - 深度递归（每层递归都占用栈内存，深度过深耗尽内存）。
  - 加载超大数据结构（如创建包含海量元素的列表、字典）。
- 处理方法
  - 优化算法，减少内存占用（如用生成器 `(x for x in range(...))` 代替列表存储大量数据，按需生成而非一次性加载）。
  - 及时释放不再使用的对象（使用 `del` 语句删除变量引用，加速垃圾回收）。
  - 分块处理数据（如大文件分块读取：`with open('file.txt') as f: while True: data = f.read(1024); if not data: break`）。
  - 避免无限制的递归，改用迭代等方式实现功能。
  - 监控内存使用（利用 `memory_profiler` 等工具定位内存消耗点）。

## 内存泄漏是什么？如何避免？

- **内存泄露定义**：程序中已分配的内存不再使用，但因疏忽或错误（如循环引用且含`__del__`方法。长期持有大对象引用等）无法释放，导致内存逐渐耗尽。它不是内存物理上的消失，而是程序失去对该内存段的控制，造成内存浪费
- 避免方法
  - 不用对象时及时使用 `del` 删除引用（如 `del large_list`，减少引用计数）。
  - 避免含 `__del__` 函数对象的循环引用（此类循环引用无法被引用计数机制处理，易导致内存泄露）。
  - 借助 `gc` 模块检查：`gc.garbage` 可查看程序中未被回收的对象，辅助定位泄露点。
  - 使用弱引用（`weakref` 模块）：在需要保持对象引用但又不希望影响其生命周期时，使用弱引用替代强引用，避免循环引用导致的泄露。例如：`import weakref; obj = [1, 2, 3]; weak_obj = weakref.ref(obj)`，`weak_obj` 不会增加 `obj` 的引用计数。

# 函数

## 实现了一个时间检查装饰器

```python
import datetime


class TimeException(Exception):
    def __init__(self, exception_info):
        super().__init__()
        self.info = exception_info  # 存储异常信息

    def __str__(self):
        return self.info  # 定义异常打印时的输出
def timecheck(func):
    def wrapper(*args, **kwargs):
        if datetime.datetime.now().year == 2019:
            func(*args, **kwargs)  # 允许执行
        else:
            raise TimeException("函数已过时")  # 阻止执行
    return wrapper

@timecheck
def test(name):
    print("Hello {}, 2019 Happy".format(name))


if __name__ == "__main__":
    test("backbp")
    
# Traceback (most recent call last):
#   File "C:\Users\stllc\PycharmProjects\Pro_fir\algorithm\Py测开学习.py", line 471, in <module>
#     test("backbp")
#   File "C:\Users\stllc\PycharmProjects\Pro_fir\algorithm\Py测开学习.py", line 462, in wrapper
#     raise TimeException("函数已过时")  # 阻止执行
# __main__.TimeException: 函数已过时
```

## map函数和reduce函数的区别

```python
def fun():
    ret1 = list(map(lambda x: x * x, [1, 2, 3, 4]))
    ret2 = reduce(lambda x, y: x * y, [1, 2, 3, 4])
    print(ret1)
    print(ret2)

fun()
#[1, 4, 9, 16]
#24
```

## hasattr() getattr() setattr()函数使用详解

- `hasattr(object, name)`

用于判断对象 `object` 是否包含名为 `name` 的属性或方法，返回 `bool` 值。若存在，返回 `True`；否则，返回 `False`。

```python
class function_demo(object):
    name = 'demo'
    def run(self):
        return "hello function"
functiondemo  = function_demo()
print(hasattr(functiondemo, "name"))  # True，存在 name 属性
print(hasattr(functiondemo, "run"))    # True，存在 run 方法
print(hasattr(functiondemo, "age"))    # False，不存在 age 属性
```

- `getattr(object, name[, default])`

用于获取对象 `object` 的属性或方法。



- 若 `name` 存在，返回对应属性值或方法（返回方法时是方法的内存地址，如需执行方法需添加 `()`）。
- 若 `name` 不存在且提供了 `default`，返回 `default`。
- 若 `name` 不存在且未提供 `default`，抛出 `AttributeError` 异常。

```python
print(getattr(functiondemo, "name"))  # 输出 "demo"，获取存在的属性
print(getattr(functiondemo, "run"))    # 输出方法内存地址，如 "<bound method function_demo.run of <__main__.function_demo object at 0x...>>"
print(getattr(functiondemo, "age", 18)) # 输出 18，无 age 属性但有默认值
print(getattr(functiondemo, "age"))    # 报错，无 age 属性且无默认值
```

- `setattr(object, name, value)`

用于给对象 `object` 的属性赋值。若属性 `name` 不存在，先创建该属性再赋值。

```python
setattr(functiondemo, "age", 20)  # 给对象添加 age 属性并赋值 20
print(functiondemo.age)           # 输出 20
setattr(functiondemo, "name", "new_demo")  # 修改已存在的 name 属性值
print(functiondemo.name)          # 输出 "new_demo"
```

## 什么是lambda函数？有什么好处？

**`lambda`**函数是一种匿名函数，可接受任意多个参数（含可选参数），并返回单个表达式的值，无复杂的函数定义结构

**好处：**

1. **轻便简洁**：即用即弃，适用于仅一处使用、功能简单且无需专门命名的场景。
2. **服务函数式编程**：作为匿名函数，常为 `filter`、`map` 等函数式编程工具服务，简化代码逻辑。
3. **灵活的回调应用**：可作为回调函数传递给某些应用（如消息处理），快速定义临时功能。

## 闭包的含义

**闭包(Closure)**是编程中的一个重要概念，指在一个函数内部定义另一个函数时，内部函数引用了外部函数的变量或参数，且外部函数返回内部函数后，这些被引用的变量或参数的作用域依然被保留，不会因外部函数执行结束而被销毁。

### 一、定义与构成条件

- **定义**：闭包是由函数和与其相关的引用环境（即外部函数的变量作用域）组合而成的实体。
- 构成条件
  1. 存在嵌套函数（内部函数在外部函数内定义）。
  2. 内部函数引用了外部函数的变量或参数。
  3. 外部函数返回内部函数。

### 二、核心作用

- **保留变量作用域**：外部函数执行完毕后，其变量不会被垃圾回收，供内部函数持续使用。
- **数据封装与隐藏**：通过闭包可将变量隐藏在外部函数内，避免全局变量污染，同时通过内部函数提供受控的访问接口。
- **实现函数功能扩展**：如装饰器、工厂函数等场景中，闭包可动态绑定参数或状态，增强函数灵活性。

```python
def outer(x):  # 外部函数
    def inner(y):  # 内部函数，引用外部函数的变量x
        return x + y
    return inner  # 外部函数返回内部函数

closure_func = outer(5)  # 调用outer，传入x=5
print(closure_func(3))  # 输出8（5 + 3）
```

- 调用 `outer(5)` 时，外部函数的变量 `x` 被赋值为 `5`。
- 外部函数返回 `inner` 函数后，`x=5` 的作用域被保留。
- 调用 `closure_func(3)` 时，内部函数 `inner` 利用保留的 `x=5` 与新参数 `y=3` 计算，返回 `8`。

## 闭包延迟

```python
def multpliers():
    return [lambda x:i * x for i in range(4)]
print([m(2) for m in multpliers()])
#[6, 6, 6, 6]
```

- **`multipliers` 函数**：
  通过列表推导式 `[lambda x: i * x for i in range(4)]` 创建包含 4 个 `lambda` 函数的列表。这里的 `lambda` 函数直接引用循环变量 `i`，但由于 Python 闭包的延迟绑定特性，**`i` 的值不会在列表推导式创建 `lambda` 函数时立即绑定**，而是在 `lambda` 函数被调用时才去查找 `i` 的值。

正常：

```python
def multpliers():
    return [lambda x, i = i: i * x for i in range(4)]
    # for i in range(4):
    #     yield lambda x: i *x

print([m(2) for m in multpliers()])

#[0, 2, 4, 6]
```

## 函数装饰器的作用

函数装饰器本质是一个可调用对象，它的核心作用是**在不修改原有函数代码的前提下，为函数动态添加额外功能**，实现代码的复用与解耦

- **代码复用与简化**：例如多个函数需要插入日志记录、性能测试代码，若直接写在函数内部，会导致代码冗余。使用装饰器可将这些通用逻辑抽离，统一管理。
- **切面需求处理**：对有横切需求的场景（如权限校验、事务处理），装饰器能集中处理这些与函数核心功能无关的逻辑。例如，在用户调用某些接口函数前，通过装饰器校验用户权限，无需在每个函数内重复编写校验代码。
- **保持函数原有结构**：装饰器返回值也是函数对象，被装饰的函数代码无需改动，仍可像往常一样调用，维持代码的整洁与可读性。

## 生成器，迭代器的区别

**迭代器（Iterator）**

- 是遵循迭代协议的对象，需实现 `__next__()` 方法（Python 3，Python 2 为 `next()`），用于逐个获取元素。
- 可通过 `iter()` 函数从序列（如列表、元组）生成，也可自定义类并实现 `__iter__()` 和 `__next__()` 方法。
- 当无元素可返回时，抛出 `StopIteration` 异常。

**生成器（Generator）**

- 是迭代器的一种特殊形式，**通过 `yield` 语句定义**。每次调用 `next()` 时，生成器从 `yield` 处恢复执行，返回对应值，并保留当前状态（包括变量值、执行位置）。
- **自动实现了 `iter()` 和 `__next__()` 方法**，代码更简洁。
- 按需生成数据，内存效率高。例如处理大文件逐行读取，或生成无限序列（如斐波那契数列），无需一次性加载所有数据到内存

#### 核心区别

| 特性       | 迭代器                                 | 生成器                       |
| ---------- | -------------------------------------- | ---------------------------- |
| 实现方式   | 自定义类并实现 `__next__()`            | 函数中用 `yield` 语句        |
| 内存效率   | 普通迭代（如列表迭代）可能占用较多内存 | 按需生成，内存高效           |
| 代码简洁性 | 需手动实现迭代逻辑                     | 自动管理迭代状态，代码更简洁 |
| 本质关系   | 生成器是迭代器的一种                   | —                            |

## 实现将1-n的整数列表以3为单位分组

```python
# 内层列表推导式：[x for x in range(1, 100)]
# 生成一个包含 1 到 99 的列表，共 99 个元素，即 [1, 2, 3, ..., 99]。
# 切片操作：[i:i+3]
# 对上述列表进行切片，每次取连续的 3 个元素。例如，i=0 时取 [1, 2, 3]，i=3 时取 [4, 5, 6]，以此类推。
# 外层列表推导式：for i in range(0, 100, 3)
# 控制切片的起始位置 i，取值为 0, 3, 6, ..., 99（共 33 个值），确保恰好将 99 个元素分成 33 组，每组 3 个元素。
N = 100
print([[x for x in range(1, 100)] [i:i+3] for i in range(0, 100, 3)])
```
