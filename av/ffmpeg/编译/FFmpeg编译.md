## FFmpeg编译

- Makefile
- configure



### Makefile

config.mak：由configure生成的Makefile，保存了Configure的设置信息；
libavXXXX/Makefile：每个类库的Makefile（仅仅设置了几个变量）；
library.mak：编译类库的Makefile（和libavXXXX/Makefile配合使用）；
common.mak：包含一些通用代码的Makefile；

根目录的Makefile中有一个很重要的命令包DOSUBDIR。在该命令包通过包含libavXXX/Makefile和library.mak等文件，定义了FFmpeg类库（例如libavformat，libavcodec，libavutil等）的依赖关系。





#### Configure

使用“sh -x script_name.sh”可以调试Shell脚本。

Configure的整体流程可以分为以下几步：

1. Set Default Value：设置各个变量默认值；
2. Parse Options：解析输入的选项；
3. Check Compiler：检查编译器；
4. die_license_disabled()：检查GPL等协议的设置情况；
5. Check：检查编译环境（数学函数，第三方类库等）；
6. Echo info：控制台上打印配置信息；
7. Write basic info：向config.mak中写入一些基本信息； 
8. print_config()：向config.h、config.mak、config.asm中写入所有配置信息；
9. print_enabled()：向config.mak写入所有enabled的组件信息；
10. pkgconfig_generate()：向libavXXX/libavXXX.pc中写入pkgconfig信息（XXX代表avcodec，avformat等）