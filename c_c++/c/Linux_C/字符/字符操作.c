strchr() 用来查找某字符在字符串中首次出现的位置，其原型为：
    char * strchr (const char *str, int c);
        [参数] str 为要查找的字符串，c 为要查找的字符。
strchr() 将会找出 str 字符串中第一次出现的字符 c 的地址，然后将该地址返回。

strncmp() 用来比较两个字符串的前n个字符，区分大小写，其原型为：
    int strncmp ( const char * str1, const char * str2, size_t n );
    [参数] str1, str2 为需要比较的两个字符串，n为要比较的字符的数目。

strlen()函数用来计算字符串的长度，其原型为：
    unsigned int strlen (char *s);
    [参数说明] s为指定的字符串。
    strlen()用来计算指定的字符串s 的长度，不包括结束字符"\0"。
    [返回值] 返回字符串s 的字符数。

abort(): 终止程序


strtol() 函数用来将字符串转换为长整型数(long)，其原型为：
    long int strtol (const char* str, char** endptr, int base);
    [参数说明] str 为要转换的字符串，endstr 为第一个不能转换的字符的指针，base 为字符串 str 所采用的进制。
    [函数说明] strtol() 会将参数 str 字符串根据参数 base 来转换成长整型数(long)。参数 base 范围从2 至36，或0。参数base 代表 str 采用的进制方式，如base 值为10 则采用10 进制，若base 值为16 则采用16 进制等。
    strtol() 会扫描参数 str 字符串，跳过前面的空白字符（例如空格，tab缩进等，可以通过 isspace() 函数来检测），直到遇上数字或正负符号才开始做转换，再遇到非数字或字符串结束时('\0')结束转换，并将结果返回。

getenv()
    #include <stdlib.h>
    定义函数：char * getenv(const char *name);
    函数说明：getenv()用来取得参数name 环境变量的内容. 参数name 为环境变量的名称, 如果该变量存在则会返回指向该内容的指针. 环境变量的格式为name＝value.
    返回值：执行成功则返回指向该内容的指针, 找不到符合的环境变量名称则返回NULL.

time()
    #include <time.h>
    定义函数：time_t time(time_t *t);
    函数说明：此函数会返回从公元 1970 年1 月1 日的UTC 时间从0 时0 分0 秒算起到现在所经过的秒数。如果t 并非空指针的话，此函数也会将返回值存到t 指针所指的内存。
    返回值：成功则返回秒数，失败则返回((time_t)-1)值，错误原因存于errno 中。

localtime():
    #include <time.h>
    定义函数：struct tm *localtime(const time_t * timep);
    函数说明：localtime()将参数timep 所指的time_t 结构中的信息转换成真实世界所使用的时间日期表示方法，然后将结果由结构tm 返回。结构tm 的定义请参考gmtime()。此函数返回的时间日期已经转换成当地时区。
    返回值：返回结构tm 代表目前的当地时间。