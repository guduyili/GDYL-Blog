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

[原题]("https://leetcode.cn/problems/linked-list-cycle-ii/")

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

