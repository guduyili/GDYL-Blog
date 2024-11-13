---
title: Linux的内存和硬盘管理
date: 2024-11-10
updated: 2024-11-10
categories: 
- Linux
tag:
- learning
---

<!--toc-->



## 查看

```bash
# 内存查看
free    显示内存的大小-m:多少兆显示  -g：按G显示会被四舍五入	
linux 内存使用原则  如果有多余的内存  就尽可能多的去占用  一个程序申请内存空间都是会有一定的开销的
swap 交换分区 ：当available = 0 linux就会把一部分暂时不需要的内存 移动到swap上面
如果不用swap  当内存满的使用 linux就会出现随机杀掉占用内存最大的进程机制  一般都是核心进程  
不可预知的错误  尽可能避免  

top 动态查看



# 磁盘查看
fdisk
df
du
du与ls区别

ls查看的是 i 节点的信息    du 统计的是数据块个数的信息
```

