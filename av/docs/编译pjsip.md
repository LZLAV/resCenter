sudo apt-get update



安装 make

sudo apt-get install make

安装gcc

系统自带

sudo apt-get install gcc

安装 g++

sudo apt-get install g++



下载jdk

配置jdk环境变量

下载ndk

配置ndk环境变量



安装 swig	(进行嵌入联接的开发工具)

https://blog.csdn.net/zhangkzz/article/details/88555830



安装pcre

https://www.cnblogs.com/zkfopen/p/10156494.html



ldd 查看依赖库

ldd swig



软连接

ln -s /usr/local/lib/libpcre.so.1.2.10 libpcre.so.1



设置LD_LIBRARY_PATH

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH



安装python 3

安装以来环境

yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

