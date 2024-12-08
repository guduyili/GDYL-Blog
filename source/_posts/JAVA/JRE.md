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

# 反射

- 反射是指在运行时检查和操作类，接口，字段，方法等程序结构的能力。通过反射，可以在运行时获取类的信息，创建类的实例，调用类的方法，访问和修改类的字段。

1. 反射第一步：加载类，获取类的字节码：Class对象
2. 获取类的构造器：Constructor对象
3. 获取类的成员变量：Field对象
4. 获取类的成员方法：Method对象

## 1.获取Class

```java
public class ReflectDemo {
        public static void main(String[] args) {
                // 1.获取类本身，class 类
                Class c1 = Student.class;
                System.out.println(c1);
                // 2.获取类的本身 Class.forName("类的全类名")
                Class c2;
                try {
                        c2 = Class.forName("gdyl.com.demoreflect1.Student");
                        System.out.println(c2);
                } catch (ClassNotFoundException e) {
                        throw new RuntimeException(e);
                }
                // 3.获取类的本身，对象，getClass()
                Student stu = new Student();
                Class c3 = stu.getClass();
                System.out.println(c3);

                System.out.println(c1 == c2);//true
                System.out.println(c1 == c3);//true
        }

}


```

## 2.获取类的成分并对其操作

```java
public class ReflectDemo2 {
@Test
public void getClassInfo(){
        //1.获取Class类
        Class jw = JW.class;
        System.out.println(jw.getName());
        System.out.println(jw.getSimpleName());
}

//2.获取类的构造器对象并对其进行操作
@Test
public  void getConstructorInfo() throws  Exception{
        //1.获取Class类
        Class jw = JW.class;
        //2.获取构造器对象
        Constructor[] cons = jw.getDeclaredConstructors();
        for(Constructor tmp : cons){
                System.out.println(tmp.getName() + "(" + tmp.getParameterCount() +")");
        }
        //3.获取单个构造器
        Constructor con1 = jw.getDeclaredConstructor();//无参构造器
        System.out.println(con1.getName() + "(" + con1.getParameterCount() +")");

        Constructor con2 = jw.getDeclaredConstructor(int.class);//一个有参构造器
        System.out.println(con2.getName() + "(" + con2.getParameterCount() +")");

        //4.获取构造器的作用依然是创建对象
        //暴力反射 可以访问私有的构造器，方法，属性
        con1.setAccessible(true);
        JW test = (JW)con1.newInstance();
        System.out.println(test);

        JW test2 = (JW)con2.newInstance(114514);
        System.out.println(test2);
}
//3.获取类的成员变量对象并对其操作
@Test
public void getFieldInfo()throws Exception{
        //1.获取Class类
        Class jw = JW.class;
        //2.获取成员变量对象
        Field[] fields = jw.getDeclaredFields();
        for(Field field : fields){
                System.out.println(field.getName() + "(" + field.getType().getName() +")");
        }
        //3.获取单个成员变量对象
        Field field = jw.getDeclaredField("game");
        System.out.println(field.getName() + "(" + field.getType().getName() +")");

        Field field1 = jw.getDeclaredField("age");
        System.out.println(field1.getName() + "(" + field1.getType().getName() +")");


}

//4.获取类的成员方法对象并对其进行操作
@Test
public void getMethodInfo()throws Exception{
        //1.获取Class类
        Class jw = JW.class;
        //2.获取成员方法对象
        Method[] methods = jw.getDeclaredMethods();
        for(Method tmp : methods){
                System.out.println(tmp.getName() + "(" + tmp.getParameterCount() +")");
        }
        //3.获取单个成员方法对象
        Method test1 = jw.getDeclaredMethod("GFJW");
        Method test2 = jw.getDeclaredMethod("GFJW",String.class);
        System.out.println(test1.getName() + "(" + test1.getParameterCount() +")");
        System.out.println(test2.getName() + "(" + test2.getParameterCount() +")");

        //4.获取成员方法以来调用方法
        JW tmp = new JW(1919,"xcjw","genshinimpact");
        test1.setAccessible(true);
        Object ret1 = test1.invoke(tmp);//唤醒对象那个tmp的GFJW方法执行，相当于tmp.GFJW();
        System.out.println(ret1);//null

        Object ret2 = test2.invoke(tmp,"伯约");//唤醒对象那个tmp的GFJW的带参方法执行，相当于tmp.GFJW("伯约");
        System.out.println(ret2);

}
}

```

```java
// JW
package gdyl.com.demoreflect1;

/***
 *@title JW
 *@description <TODO description class purpose>
 *@author lzy33
 *@version 1.0.0
 *@create 7/12/2024 下午 4:12
 **/
public class JW {
    private int age;
    private  String name;
    private  String game;

    private JW() {
        System.out.println("无参构造器");
    }

    public JW(int age, String name, String game) {
        this.age = age;
        this.name = name;
        this.game = game;
        System.out.println("三个参数有参构造器");
    }
    public JW(int age) {
        this.age = age;
        System.out.println("一个参数有参构造器");
    }

    private  void GFJW(){
        System.out.println("我是国服姜维");
    }
    public  String GFJW(String name){
        System.out.println( name+"是国服姜维");
        return "国服姜维";
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGame() {
        return game;
    }

    public void setGame(String game) {
        this.game = game;
    }
    @Override
    public String toString(){
        return String.format("姜维对象[年龄:%d,名字:%s，游戏:%s]",
                age,
                name != null ? name: "未设置",
                game != null ? game: "未设置"
        );
    }
}

```

## 反射的作用

- 基本作用：可以得到一个类的全部成分然后操作

- 可以破坏封装性

- 可以绕过泛型的约束

- java框架使用

  ```java
  public class ReflectDemo3 {
          public static void main(String[] args) throws Exception {
                  ArrayList<String>list = new ArrayList<>();
                  list.add("国服姜维");
                  list.add("名姜维");
                  list.add("字伯约");
                  //不能添加int boolen
                  // list.add(1145);
                  // list.add(false);
  
                  Class tmp = list.getClass();
                  //获取ArrayList类中的add方法
                  Method add = tmp.getDeclaredMethod("add",Object.class);
  
                  add.invoke(list,114514);
                  add.invoke(list,true);
  
                  System.out.println(list);
          }
  
  }
  ```

  

## 框架测试

```java
public class SaveObjectFrameWork {
    public static void SaveObject(Object obj)throws  Exception {
        PrintStream ps = new PrintStream(new FileOutputStream("gdyl.com\\src\\main\\java\\gdyl\\com\\obj.txt",true));

        Class tmp = obj.getClass();
        String simpleName = tmp.getSimpleName();
        ps.println("========" + simpleName + "========");

        Field[] fields = tmp.getDeclaredFields();

        for(Field field : fields){
            String fieldName = field.getName();

            field.setAccessible(true);
            Object fieldValue = field.get(obj) + "";

            ps.println(fieldName + "=" + fieldValue);

        }
        ps.close();
    }

```

```java
//Student
public class Student {
    private  String name;
    private  int age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
```

```java
public class ReflectDemo4 {
        public static void main(String[] args) throws Exception {

                JW jw = new JW(1919,"姜维伯约","genshinimpact","看二次元");
                SaveObjectFrameWork.SaveObject(jw);

                Student stu = new Student("消愁姜维",1145);
                SaveObjectFrameWork.SaveObject(stu);
        }

}
```



# 注解

**自定义注解**

- 自定义注解

  ```java
  public @interface 注解名称{
      public 属性类型 属性名（） default 默认值();
  }
  ```

**特殊属性名: value**

- 如果注解中只有一个value属性，使用注解时，value名称可以不写

## @Target

**作用：声明被修饰的注解只能在哪些位置使用**

@Target(ElementType.TYPE)

1. TYPE,类，接口
2. FIELD，成员变量
3. METHOD,成员方法
4. PARAMETER,方法参数
5. CONSTRUCTOR,构造器
6. LOCAL_VARIABLE,局部变量

## @Retention

**作用：声明注解和保留周期**

@Retention（RetentionPolicy.RUNTIME）

1. SOURCE
   -  只作用在源码阶段
2. CLASS(默认值)
   - 保留到字节码文件阶段，运行阶段不存在
3. RUNTIME（开发常用）
   - 一直保留到运行阶段

## 注解的解析

```java
public class AnnotaionDemo2 {
  //解析注释
    @Test
    public void parseClass() throws  Exception{
        //1.获取类对象
        Class tmp= Demo.class;

        //2.判断这个类上是否陈列了注解MyTest2
        if(tmp.isAnnotationPresent(MyTest2.class)){
            //3.获取注解对象
            MyTest2 myTest2 = (MyTest2)tmp.getAnnotation(MyTest2.class);

            //4.获取注解属性值
            String[] address = myTest2.address();
            double money = myTest2.money();
            String value = myTest2.value();

            //5.打印注解属性值
            System.out.println(value);
            System.out.println(money);
            System.out.println(Arrays.toString(address));
        }
    }
    @Test
    public void parseMethod()throws Exception{
        //1.获取类对象
        Class tmp= Demo.class;

        //2.获取方法对象
        Method method = tmp.getMethod("test");

        //3.使用isAnnotationPresent判断这个方法上石油陈列了注解MyTest2
        if(method.isAnnotationPresent(MyTest2.class)){
            //4.获取注解对象
            MyTest2 myTest2 = method.getDeclaredAnnotation(MyTest2.class);

            //5.获取注解属性值
            String[] address = myTest2.address();
            double money = myTest2.money();
            String value = myTest2.value();

            //6.打印注解属性值
            System.out.println(value);
            System.out.println(money);
            System.out.println(Arrays.toString(address));
        }
    }
}


@MyTest2(value = "姜维伯约",address = {"蜀国","魏国"})
public class Demo {

    @MyTest2(value = "诸葛孔明",address = {"韩国","魏国"})
    public void test(){

    }

}
```

