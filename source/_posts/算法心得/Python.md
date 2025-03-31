---
title: Py刷题有感       
date: 2025-03-07
updated: 2025-03-07
categories: 
- 算法
tag:
- learning
---

<!-- toc -->

[TOC]

## 环形链表 II

[原题](https://leetcode.cn/problems/linked-list-cycle-ii/)

![image-20250307163008115](https://s2.loli.net/2025/03/07/zsu6VMSp7HYlcnQ.png)

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def detectCycle(self, head: Optional[ListNode]) -> Optional[ListNode]:

        slow  = fast = head
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            if fast is slow:
               #以上和环形链表一样

             while slow is not head:
                slow = slow.next
                head = head.next
                
             return slow
        return None
            
#假设将路径循环分为a b c三段
#其中a为共同路径进入循环的入口
#b为相遇的点 c为回到a的路径
#那么快慢指针分别走了 a+b a+b+k(b+c)
#其中 a+b+k(b+c) = 2(a+b)
#可以解出 a-c = (k-1)(b+c)
#即为从相遇开始慢指针和head节点同时出发
#那么当一同走了c步后head到循环入口为(k-1)(b+c)而慢指针已经走到路口，它们总会在入口相遇
```

## 随机链表的复制

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, x: int, next: 'Node' = None, random: 'Node' = None):
        self.val = int(x)
        self.next = next
        self.random = random
"""

class Solution:
    def copyRandomList(self, head: 'Optional[Node]') -> 'Optional[Node]':
        if not head: return
        dic = {}
        # 复制各节点
        cur = head
        while cur:
            dic[cur] = Node(cur.val)
            cur  = cur.next
        cur = head
        # 构建random指向
        while cur:
            dic[cur].next = dic.get(cur.next)
            dic[cur].random = dic.get(cur.random)
            cur  = cur.next
        return dic[head]

```



## 自定义函数值通用位移



```python
def move(value,n):
    value = value & 0xFFFFFFFF #确保是32位无符号整数
    n = n % 32
    if n > 0: #右移n位
        return ((value >> n) | (value << (32 - n))) & 0xFFFFFFFF
    else: #右移n位
        return ((value << n) | (value >> (32 - n))) & 0xFFFFFFFF
    
    #输入处理
value , n = map(int,input().split())
ret = move(value,n)
print(ret)
```

1. **`value & 0xFFFFFFFF`**：
   - 确保 `value` 是 **32位无符号整数**（丢弃高于 32 位的部分）。
2. **`n = n % 32`**：
   - 将位移位数限制在 `0~31` 之间（题目已保证 `|n| ≤ 30`，所以这步可以省略）。
3. **右移 `n` 位**：
   - `(value >> n)`：正常右移 `n` 位，高位补 0。
   - `(value << (32 - n))`：将“被移出”的 `n` 位左移到最左侧。
   - `|` 运算：合并两部分，实现循环右移。
   - `& 0xFFFFFFFF`：确保结果仍是 32 位。
4. **左移 `n` 位**：
   - `(value << n)`：正常左移 `n` 位，低位补 0。
   - `(value >> (32 - n))`：将“被移出”的 `n` 位右移到最右侧。
   - `|` 运算：合并两部分，实现循环左移。
   - `& 0xFFFFFFFF`：确保结果仍是 32 位。

例子展示：

1. `value = 128`（二进制 `0000...00010000000`，共 32 位）。
2. 左移 3 位：
   - `128 << 3` = `1024`（二进制 `0000...01000000000`）。
   - `128 >> (32 - 3)` = `128 >> 29` = `0`（因为 128 的高 29 位全是 0）。
   - 合并结果：`1024 | 0 = 1024`。

## 最小公约数与最大公约数

```python
a,b = map(int,input().split())
m = max(a,b)
#先从最大值递减寻求最大公倍数
#最小公约数=两数相乘/最大公约数
for i in range(m,1,-1):
    if a% i==0 and b % i ==0:
        print(i,'%d'%(a*b/i))
        break
```

## 一元二次方程

```python
import math


def greater_than_zero(a, b, discriminant):
    x1 = (-b + math.sqrt(discriminant)) / (2 * a)
    x2 = (-b - math.sqrt(discriminant)) / (2 * a)
    return f"x1={x1:.3f} x2={x2:.3f}"


def equal_to_zero(a, b):
    x = -b /(2 *a)
    return f"x1={x:.3f} x2={x:.3f}"


def less_than_zero(a, b, discriminant):
    real_part = -b /(2 *a)
    imaginary_part = math.sqrt(-discriminant) /(2 *a)
    return f"x1={real_part:.3f}+{imaginary_part:.3f}i x2={real_part:.3f}-{imaginary_part:.3f}i"


def solve_quadratic_equation():
    # 输入系数
    a, b, c = map(float, input().split())

    # 计算判别式
    discriminant = b ** 2 - 4 * a * c

    # 根据判别式值选择不同的函数求解
    if discriminant > 0:
        print(greater_than_zero(a, b, discriminant))
    elif discriminant == 0:
        print(equal_to_zero(a, b))
    else:
        print(less_than_zero(a, b, discriminant))


# 调用主函数
solve_quadratic_equation()

```

### 神奇闹钟（时间格式处理）

```python
import sys
from datetime import datetime,timedelta


def find_last_alarm(time_str, x):
    # 解析输入时间为datetime对象
    given_time = datetime.strptime(time_str, "%Y-%m-%d %H:%M:%S")
    # 纪元时间
    epoch = datetime(1970, 1, 1, 0, 0, 0)
    # 计算时间差
    delta = given_time - epoch
    # 将时间差转换为总秒数
    total_seconds = int(delta.total_seconds())
    # // 表示整数除法（向下取整）
    total_minutes = total_seconds // 60
    # 计算完整的间隔周期数量
    # * x 得到最后一个完整周期结束时的分钟数
    # total_minutes=100, x=15 → 100//15=6 → 6*15=90
    last_alarm_minutes = (total_minutes // x) * x
    # 计算对应的闹铃时间
    last_alarm_time = epoch + timedelta(minutes=last_alarm_minutes)
    # 格式化为字符串
    return last_alarm_time.strftime("%Y-%m-%d %H:%M:%S")


def main():
    # sys.stdin：标准输入流，用于读取用户输入。
    # line.strip()：移除每行首尾的空白字符（如空格、换行符等）。
    # if line.strip()：过滤掉空行，确保列表中只包含有效的输入行。
    input_lines = [line.strip() for line in sys.stdin if line.strip()]
    T = int(input_lines()[0])
    for i in range(1,T+1):
        # 将当前行按空格分割成列表
        parts = input_lines[i].split()
        # 将parts中除最后一个元素外的所有元素用空格连接成一个字符串
        # [:-1] 是 Python 的切片操作，表示取从开始到倒数第一个元素（不包含最后一个元素）。
        # join() 是字符串方法，用于将列表中的字符串元素用指定的分隔符连接成一个新字符串。
        # 这里的分隔符是空格 ' '。
        # ' '.join(['2016-09-07', '18:24:33']) → "2016-09-07 18:24:33"
        time_str = ' '.join(parts[:-1])
        # 将最后一个元素转换成整数
        x = int(parts[-1])
        print(find_last_alarm(time_str,x))
if __name__ == "__main__":
    main()
```

