---
title: JVM
date: 2024-09-25
updated: 2024-09-25
tag:
- learning
---

# 1.字节码文字
```java
public class Demo1 {
    public static void main(String[] args) {
        int i = 0;  // 初始化 i 为 0
        i++;        // i 自增 1
        System.out.println(i);  // 输出 i 的值
    }
} 
```

```bash
0 iconst_0           // 将整数 0 压入操作数栈
 1 istore_1           // 将栈顶的值（0）存储到局部变量表的第 1 个位置，即变量 i
 2 iinc 1 by 1        // 对局部变量表中的第 1 个变量 i 执行自增操作 (i = i + 1)
 5 getstatic #7       // 获取静态字段 java/lang/System.out（即标准输出流 PrintStream）
 8 iload_1            // 将局部变量表中第 1 个变量 i 的值（1）加载到操作数栈
 9 invokevirtual #13  // 调用 PrintStream 对象的 println(int) 方法，打印栈顶的值
12 return             // 返回，结束 main 方法
```


# 2.字节码常见工具使用
## 1.Arthas
``` bash
$ cd C:\Intellij\arthas\arthas-bin
$ java -jar arthas-boot.jar
$ 选择对应运行的程序 按下对应数字
$ dump -d 对应文件位置 将已加载类的字节码文件保存到特定目录
例如：dump -d /tmp/output java.lang.String
这个命令的作用是：
将 java.lang.String 类的字节码文件导出
保存到 /tmp/output 目录下

$ jad 加上对应类的全限定名 反编译已经加载类的源码
```
![1.png](https://i.postimg.cc/KYPhs1CR/1.png)

