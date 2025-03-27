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

