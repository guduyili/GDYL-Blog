---
title: TCP/IP
date: 2024-10-8
updated: 2024-10-8
categories: 
- HCIA
tag:
- learning
---

<!-- toc -->

## TCP/IP 标准模型
- 应用层
- 主机到主机层
- 英特网层
- 网络接入层



## TCP/IP 对等模型
- 应用层        数据DATA
- 传输层        段Segment
- 网络层        包Packet
- 数据链路层     帧Frame
- 物理层        位Bit

## TCP/IP 常见协议
- 应用层: Telent  FTP  TFTP  SNMP
    - HTTP  SMTP  DNS  DHCP
- 传输层: TCP  UDP
- 网络层: ICMP  IGMP
    - IP 
- 数据链路层: PPPoE
    - Ethernet  PPP   
- 物理层:  .....


## 以太网MAC地址
- MAC(Media Access Control)地址在网络中唯一标识的一个网卡
    - 每个网卡都需要且会有唯一的一个MAC地址
- MAC用于在一个IP网段内，寻址找到具体的物理设备
- 工作在数据链路层的设备。例如以太网交换机，会维护一张MAC地址表
    - 用于知道数据帧转发

### 常见问题

**路由器工作在网络层**：路由器（Router）是网络设备，用于在不同网络之间转发数据包。路由器根据网络层（Layer 3）的IP地址来决定数据包的转发路径，因此它工作在**网络层**。



**交换机工作在数据链路层**：交换机（Switch）主要工作在**数据链路层**（Layer 2），根据MAC地址来转发数据包。不过，有些高端的交换机（如三层交换机）也可以在网络层工作，但它们大多数还是在数据链路层工作。





