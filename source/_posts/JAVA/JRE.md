---
title: JRE
date: 2024-12-02
updated: 2024-12-02
categories: 
- JAVA
tag:
- JAVA
---
<!-- toc -->

# IO流

## Fileinputstream

```java
public class demo1 {
    public static void main(String[] args) throws Exception {
        //1. 创建文件字节输入流管道与源文件接通
        //InputStream is = new FileInputStream(new File("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei02.txt"));
        InputStream is = new FileInputStream("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei02.txt");

        //2.开始读取文件中的字节并输出，每次读取一个字节
        //定义一个变量记住每次读取的一个字节
        int tmp;
        while((tmp = is.read()) != -1){
            System.out.print((char)tmp);
        }
        //每次读取一个字节：性能较差，读取汉字输出一定会乱码
        is.close();
    }
}

public class demo2 {
    public static void main(String[] args) throws Exception {
        //1. 创建文件字节输入流管道与源文件接通
        //InputStream is = new FileInputStream(new File("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei02.txt"));
        InputStream is = new FileInputStream("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei02.txt");

        //2.开始读取文件中的字节并输出，每次读取多个字节
        //定义一个字节数组用于每次读取字节
        byte[] buffer= new byte[3];
        //定义一个变量记住每次读取了多少个字节
        int len;
        while((len = is.read(buffer)) != -1){
            //3.把读取到的字节数组转换成字符串输出
            String str = new String(buffer,0,len);
            System.out.println(str);
        }
		is.close();
    }
}

public class demo3 {
    public static void main(String[] args) throws Exception {
        //1. 创建文件字节输入流管道与源文件接通
        //InputStream is = new FileInputStream(new File("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei02.txt"));
        InputStream is = new FileInputStream("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei02.txt");

        //2.一次性读完全部字节
        byte[] bytes= is.readAllBytes();

        String tmp = new String(bytes);
        System.out.println(tmp);

		is.close();
    }
}

```

## FileOutPutStream

```java
public class FileOutPutStreamDeam1 {
    public static void main(String[] args) throws Exception {
        //1. 创建文件字节输出流管道和目标文件接通
        //OutputStream os = new FileOutputStream("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei03-out.txt");//覆盖通道
        OutputStream os = new FileOutputStream("gdyl.com\\src\\main\\java\\gdyl\\com\\dlei03-out.txt",true);//追加数据


        //2. 写入数据
        //public void write(int b)
        os.write(97);//写入一个字节数据
        os.write('b');//写入一个字符数据
        // os.write('姜');//写入一个字符数据 乱码
        os.write("\r\n".getBytes());//换行

        //3. 写一个字节数组进去
        //public void write(byte[] b)
        byte[] bytes = "国服姜维".getBytes();
        os.write(bytes);
        os.write("\r\n".getBytes());//换行

        //4. 写一个字节数组的一部分进去
        //public void write(byte[] b,int pos,int len)
        os.write(bytes,0,3);//只有三个字节一个字
        os.write("\r\n".getBytes());//换行
        os.write(bytes,6,6);
        os.write("\r\n".getBytes());//换行

        os.close();
    }

}
```

