---
title: Py刷题有感       
date: 2025-03-07
updated: 2025-04-01
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

## 连连看

```python
# 导入defaultdict， 用于创建自动初始化默认值的字典（避免键不存在时的KeyError）
from collections import  defaultdict

# 遍历每条对角线
n, m = map(int, input().split())
# 按行输入数据
grid = [list(map(int,input().split())) for _ in range(n)]
# 创建字典，键为数值，值为该数值在网格中的所有位置（i,j)的列表
# value_positions = {
#     1: [(0, 0)],       # 数值1在(0,0)
#     2: [(0, 1), (1, 0), (2, 1)],  # 数值2在(0,1)、(1,0)、(2,1)
#     3: [(1, 1), (2, 0)] # 数值3在(1,1)、(2,0)
# }
value_positions = defaultdict(list)

# 遍历网格
for i in range(n):
    for j in range(m):
        value_positions[grid[i][j]].append((i, j))

ret = 0
for v in value_positions:
    positions = value_positions[v]
    # 初始化两个字典，分别统计同一数值在主对角线和副对角线上出现的次数
    main_diag = defaultdict(int)
    anti_diag = defaultdict(int)
    for i, j in positions:
        main_diag[i - j] += 1  # 主对角线分组（左上到右下）
        anti_diag[i + j] += 1  # 副对角线分组（右上到左下）
    for cnt in main_diag.values():
        ret += cnt * (cnt - 1)
    for cnt in anti_diag.values():
        ret += cnt * (cnt - 1)

print(ret)


# 测试数据
# 3 2
# 1 2
# 2 3
# 3 2

```

## 魔法巡游

```python
# 这道题目属于 动态规划（Dynamic Programming, DP） 结合 贪心优化 的序列问题
# 1. 核心算法类型
# 最长交替序列问题：
# 需要找到小蓝和小桥交替选择符文石的最长序列，且相邻元素满足特定条件（存在共鸣数字 0, 2, 4）。
#
# 动态规划（DP）：
# 状态转移依赖于前一个选择的符文石及其类型（小蓝或小桥的石头），通常用 dp_s[i] 和 dp_t[j] 分别表示以 s[i] 或 t[j] 结尾的最长序列长度。
n = int(input())
arr1 = [0] + list(map(int, input().split()))
arr2 = [0] + list(map(int, input().split()))


# 检查数字的各位是否由是偶数且小于5的数 即为 0 2 4
def check(x):
    while x > 0:
        tmp = x % 10    # 取最后一位
        if tmp % 2 == 0 and tmp < 5:
            return True
        x = x // 10     # 去掉最后一位
    return False

turn = 0  # 切换标志（0: arr1, 1: arr2）
ret = 0
for i in range(1,n+1):
    if turn == 0: # 查询arr1
        if check(arr1[i]):
            ret += 1
            turn = 1
    else:
        if check(arr2[i]):
            ret += 1
            turn = 0
print(ret)
```

## 近似 GCD

```python
import sys
import math
from functools import reduce  # 用于将多个元素的GCD计算函数进行折叠

# 定义计算列表元素最大公约数的函数
def list_gcd(lst):
    if not lst:  # 如果列表为空（理论上子数组长度≥2，此处处理边界情况）
        return 0
    # 使用reduce将math.gcd函数应用到列表的所有元素，计算整体GCD
    return reduce(math.gcd, lst)

def main():
    # 读取输入：n为数组长度，g为目标近似GCD值
    n, g = map(int, sys.stdin.readline().split())
    # 读取数组元素
    a = list(map(int, sys.stdin.readline().split()))
    count = 0  # 统计满足条件的子数组数量

    # 遍历所有可能的子数组起始位置L（从0到n-2，确保子数组长度≥2）
    for L in range(n):
        # 遍历所有可能的子数组结束位置R（R > L，保证子数组长度≥2）
        for R in range(L + 1, n):
            # 提取当前子数组（包含L到R的所有元素，左闭右闭区间）
            sub = a[L:R+1]
            # 子数组长度（可通过R-L+1计算，此处暂未使用）
            len_sub = R - L + 1
            # 计算当前子数组的原始最大公约数
            all_gcd = list_gcd(sub)

            # 条件1：原始GCD直接等于g，满足近似GCD条件
            if all_gcd == g:
                count += 1  # 计数加一
                continue  # 跳过后续检查，处理下一个子数组

            # 条件2：检查是否可以通过修改一个元素使GCD为g
            found = False  # 标记是否找到符合条件的修改位置
            # 遍历子数组中的每个元素，尝试删除当前元素后计算剩余元素的GCD
            for i in range(len_sub):
                # 分割子数组：左边是i之前的元素，右边是i之后的元素
                left = sub[:i]       # 左半部分（不包含i位置元素）
                right = sub[i+1:]    # 右半部分（不包含i位置元素）
                # 合并左右部分，计算删除i位置元素后的GCD
                h = list_gcd(left + right)
                # 如果删除后的GCD是g的倍数（修改i位置元素为g的倍数后，整体GCD可能为g）
                # 注意：这里实际逻辑应为删除该元素后剩余元素的GCD能被g整除，因为修改该元素为g的倍数后，新元素与剩余元素的GCD至少为g的因数
                if h % g == 0:  # 正确逻辑：剩余元素的GCD必须是g的倍数，这样修改当前元素为g的倍数后，整体GCD至少为g
                    found = True  # 找到符合条件的位置
                    break  # 无需检查其他位置，跳出循环

            # 如果存在至少一个位置修改后满足条件
            if found:
                count += 1  # 计数加一

    # 输出最终结果
    print(count)

if __name__ == "__main__":
    main()  # 调用主函数
```

## 管道

```python
def check(t):
    ls = []
    for i, (x, y) in enumerate(vle):
        if t >= y:
            # 计算阀门在时间 t 时的覆盖区间：中心 x，半径 (t - y)，区间为 [x - r, x + r]
            r = t - y
            ls.append((x - r, x + r))    # 将阀门展开为区间
    ls.sort()  # 按区间左端点排序
    if len(ls) == 0:
        return False  # 没有任何有效区间，无法覆盖
    if ls[0][0] > 1:
        return False  # 第一个区间的左端点超过 1，无法覆盖起点
    r = ls[0][1]  # 初始化当前覆盖的最右端点
    for i in range(1, len(ls)):             # 判断是否能够覆盖区间
        # 当前区间的左端点 <= 前一个区间的右端点 + 1（允许相邻不重叠，如 [1,3] 和 [4,5] 无法覆盖 [1,5]）
        if ls[i][0] - r <= 1:
            r = max(r, ls[i][1])  # 合并区间，更新最右端点
        else:
            break  # 区间不连续，无法覆盖
    return r >= lon  # 判断最终覆盖是否到达或超过 lon
n, lon = map(int, input().split())  # 输入阀门数量和目标长度
vle = []
for i in range(n):
    vle.append(list(map(int, input().split())))  # 存储每个阀门的 (x, y)
l, r = 0, 10**10  # 二分搜索的左右边界，右边界足够大以覆盖所有可能情况
while l < r:                                 # 二分搜索时间，右边界需要开大一些
    mid = (l + r) // 2  # 取中间值
    if check(mid):  # 若 mid 时间能覆盖，尝试更小的时间
        r = mid
    else:  # 若不能覆盖，需要更大的时间
        l = mid + 1
print(l)  # 输出最小的满足条件的时间
```

## 取模

```python
n = int(input())
vle = []
for i in range(n):
    vle.append(list(map(int, input().split())))
for i ,(n, m) in enumerate(vle):
    seen = set()
    found = False
    for j in range(1, m+1):
        tmp = n % j
        if tmp not in seen:
            seen.add(tmp)
        else:
            print("Yes")
            found = True
            break
    if found:
        break
    print("No")
```
