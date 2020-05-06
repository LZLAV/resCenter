## libpng

### 写文件步骤

1. 初始化 libpng 结构体

   png_create_write_struct()

2. 初始化 png_infop 结构体(尺寸、位深、颜色类型)

   png_create_info_struct()

3. 设置错误点

   setjmp(png_jmpbuf(png_ptr))

4. 绑定文件 IO到 png结构体

   png_init_IO(png_prt,fp)	fp为文件

5. 设置以及写入头部信息到png文件

   png_set_IHDR()

6. 写入rgb数据到png文件

   png_write_image()

7. 写入尾部信息

   png_write_end()

8. 释放内存，销毁png结构体