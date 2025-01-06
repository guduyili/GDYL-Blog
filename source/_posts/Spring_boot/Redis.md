---
title: Redis
date: 2025-01-02
updated: 2025-01-02
categories: 
- Redis
tag:
- learning
---

<!--toc-->

[toc]

- Redis是基于**内存**的key-value结构数据库

# 数据类型

![image-20250102161939619](https://s2.loli.net/2025/01/02/EcQ8pPOqxiH1MyK.png)

![image-20250102162320448](https://s2.loli.net/2025/01/02/pxu9jIe78qsKvbT.png)







# 常用命令

## 字符串操作命令

![image-20250102153703741](https://s2.loli.net/2025/01/02/tEHaiswM3KUjqyX.png)

## 哈希

![image-20250102163228317](https://s2.loli.net/2025/01/02/2xYUXz3SPuvTFAE.png)



## 列表



![image-20250102163903602](https://s2.loli.net/2025/01/02/ZgPyL5AQhnFG2i6.png)



## 集合

![](https://s2.loli.net/2025/01/02/p71ZNHQkvrLPVya.png)





## 有序集合

![image-20250102164929788](https://s2.loli.net/2025/01/02/RZcvDN9MGiJAwdr.png)





## 通用命令

![image-20250102170456039](https://s2.loli.net/2025/01/02/sqi24TpfUlAhGDI.png)

# java中Redis

```java
//RedisConfiguration
package com.sky.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;

/***
 *@title RedisConfiguration
 *@description <TODO description class purpose>
 *@author lzy33
 *@version 1.0.0
 *@create 2/1/2025 下午 9:43
 **/

@Configuration
@Slf4j
public class RedisConfiguration {

        @Bean
        public RedisTemplate redisTemplate(RedisConnectionFactory redisConnectionFactory){
            log.info("开始创建redis模板对象");
            RedisTemplate redisTemplate  = new RedisTemplate();

            //设置redis的连接工厂对象
            redisTemplate.setConnectionFactory(redisConnectionFactory);
            //设置redis key的序列化器
            redisTemplate.setKeySerializer(new StringRedisSerializer());
            return redisTemplate;

        }
}
```

```java
//SpringDataRedisTest
package com.sky.test;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.connection.DataType;
import org.springframework.data.redis.core.*;

import java.util.List;
import java.util.Set;

/***
 *@title SpringDataRedisTest
 *@description <TODO description class purpose>
 *@author lzy33
 *@version 1.0.0
 *@create 2/1/2025 下午 9:55
 **/

@SpringBootTest
public class SpringDataRedisTest {

    @Autowired
    private RedisTemplate redisTemplate;

    @Test
    public void testRedisTemplate(){
        System.out.println(redisTemplate);
        ValueOperations valueOperations = redisTemplate.opsForValue();
        HashOperations hashOperations = redisTemplate.opsForHash();
        ListOperations listOperations = redisTemplate.opsForList();
        SetOperations setOperations = redisTemplate.opsForSet();
        ZSetOperations zSetOperations = redisTemplate.opsForZSet();

    }


    /**
     * 操作哈希类型的数据
     */
    @Test
    public void testHash(){
        // hset hget hdel hkeys hvals
        HashOperations hashOperations = redisTemplate.opsForHash();

        hashOperations.put("100","name","boyue");
        hashOperations.put("100","username","jw");

        String name = (String)hashOperations.get("100","name");
        System.out.println(name);


        List values = hashOperations.values("100");
        System.out.println(values);

        hashOperations.delete("100","username");

        String username = (String)hashOperations.get("100","username");
        System.out.println(username);
    }

    /**
     * 列表
     */
    @Test
    public void testList(){
        ListOperations listOperations = redisTemplate.opsForList();

        listOperations.leftPushAll("list","114","514","1919");
        listOperations.leftPush("list","810");

        List mylist = listOperations.range("list",0,-1);
        System.out.println(mylist);

        Long size1 = listOperations.size("list");
        System.out.println(size1);

        listOperations.rightPop("list");

        Long size2 = listOperations.size("list");
        System.out.println(size2);
    }

    /**
     * 集合
     */
    @Test
    public void testSet(){
        //sadd amembers acard sinter sunion srem
        SetOperations setOperations = redisTemplate.opsForSet();

        setOperations.add("set1","a","b","c","d");
        setOperations.add("set2","a","b","f","e");

        Set memmbers = setOperations.members("set1");
        System.out.println(memmbers);

        Long size = setOperations.size("set1");
        System.out.println(size);

        Set interSet = setOperations.intersect("set1","set2");
        System.out.println(interSet);

        Set UnionSet = setOperations.union("set1","set2");
        System.out.println(UnionSet);

        setOperations.remove("set1","a");
        Set set1 = setOperations.members("set1");
        System.out.println(set1);
    }

    /**
     * 有序集合
     */
    @Test
    public void testZset(){
        //zadd zrange zincrby zrem
        ZSetOperations zSetOperations = redisTemplate.opsForZSet();

        zSetOperations.add("zset1","a",10);
        zSetOperations.add("zset1","b",12);
        zSetOperations.add("zset1","c",9);
        zSetOperations.add("zset1","d",5);

        Set zset1 = zSetOperations.range("zset1",0,-1);
        System.out.println(zset1);

        //c * 10
        zSetOperations.incrementScore("zset1","d",10);
        Set zset2 = zSetOperations.range("zset1",0,-1);
        System.out.println(zset2);

        zSetOperations.remove("zset1","a");
    }

    /**
     * 通用操作
     */
    @Test
    public void testCommon(){
        //keys exists type del
        Set keys = redisTemplate.keys("*");
        System.out.println(keys);

        Boolean name = redisTemplate.hasKey("name");
        Boolean set1 = redisTemplate.hasKey("set1");

        for(Object key:keys){
            DataType type = redisTemplate.type(key);
            System.out.println(type.name());
        }

        redisTemplate.delete("list");
    }
}

```





