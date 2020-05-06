# JAVA FILE API

java file 的使用相关问题记录



### Java中isFile与exists()的区别

**isFile()**
public boolean isFile()测试此抽象路径名表示的文件是否是一个标准文件。
抛出:SecurityException,如果存在安全管理器,且其SecurityManager.checkRead(java.lang.String)方法拒绝对文件进行读访问。

**exists()**
public boolean exists()测试此抽象路径名表示的文件或目录是否存在。
抛出:SecurityException如果存在安全管理器,且其SecurityManager.checkRead(java.lang.String)方法拒绝对文件或目录进行写访问。
————————————————
版权声明：本文为CSDN博主「pmdream」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/pmdream/article/details/81300073