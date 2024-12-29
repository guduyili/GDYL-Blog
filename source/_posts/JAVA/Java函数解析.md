---
title: Java函数解析
date: 2024-12-28
updated: 2024-12-28
categories: 
- JAVA
tag:
- JAVA
---
<!-- toc -->

## 1.*List*<*Map*<String, Object>>

```java
 List<Map<String, Object>> list = empMapper.countEmpJobData();


        //组装结果并返回
        List<Object> joblist = list.stream().map(dataMap -> dataMap.get("pos")).toList();
        List<Object> datalist = list.stream().map(dataMap -> dataMap.get("num")).toList();
```

1. list.stream()；
   - 将原始的*List*<*Map*<String, Object>>转换为Stream流
   - 允许对集合进行函数式的数据处理
2. map(dataMap -> dataMap.get("pos"))：
   - 对流中的每个元素（每个Map）执行映射操作
   - 从每个Map中提取"pos"对应的值
   - 这里假设原始list中的每个Map都包含"pos"和"num"两个键
3. `.toList()`：
   - 将Stream流转换回List
   - 收集映射后的所有值到一个新的List中