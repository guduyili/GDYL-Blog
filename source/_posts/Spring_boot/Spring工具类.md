---
title: Spring工具
date: 2025-01-13
updated: 2025-01-13
categories: 
- Spring-boot
tag:
- learning
---
<!-- toc -->

[toc]


# Spring Cache
![image-20250113122511796](C:\Users\lzy33\AppData\Roaming\Typora\typora-user-images\image-20250113122511796.png)

![](https://s2.loli.net/2025/01/13/ABSrTJLR6v1ntqy.png)

# Spring Task

![image-20250118172422144](https://s2.loli.net/2025/01/18/7wRLVnxkjYsofDE.png)

```java
@Component
@Slf4j
public class MyTask {

    @Scheduled(cron = "0/5 * * * * ?")
    public void executeTask(){
        log.info("定时任务开始执行：{}",new Date());
    }
}
```

## cron表达式

![image-20250118173216810](https://s2.loli.net/2025/01/18/hRO7VUeXn6GWJ3P.png)

# WebSocket

![image-20250122163417273](https://s2.loli.net/2025/01/22/ipXzlYFNdwc2jhR.png)
