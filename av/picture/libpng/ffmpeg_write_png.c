//RGB压缩为png图片：与ffmpeg视频解码结合存储为png图片）
void MyWritePNG2(AVFrame* pFrame, int width, int height, int iFrame)
{
    char fname[128] = { 0 };
    png_structp png_ptr;
    png_infop info_ptr;
    png_colorp palette;
 
    sprintf(fname, "frame%d.png", iFrame);
 
    FILE *fp = fopen(fname, "wb");
    if (fp == NULL)
          return ;
 
    png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
       if (png_ptr == NULL)
       {
        fclose(fp);
          return ;
       }
 
    /* Allocate/initialize the image information data.  REQUIRED */
    info_ptr = png_create_info_struct(png_ptr);
    if (info_ptr == NULL)
    {
        fclose(fp);
        png_destroy_write_struct(&png_ptr,  NULL);
        return ;
    }
    if (setjmp(png_jmpbuf(png_ptr)))
    {
       /* If we get here, we had a problem writing the file */
       fclose(fp);
       png_destroy_write_struct(&png_ptr, &info_ptr);
       return ;
    }
 
    /* 接下来告诉 libpng 用 fwrite 来写入 PNG 文件，并传给它已按二进制方式打开的 FILE* fp */
    png_init_io(png_ptr, fp);
 
    /* 设置png文件的属性 */
    png_set_IHDR(png_ptr, info_ptr, width, height, 8,
                    PNG_COLOR_TYPE_RGB,
                    PNG_INTERLACE_NONE,
                    PNG_COMPRESSION_TYPE_BASE,
                    PNG_FILTER_TYPE_BASE);
 
    /* 分配调色板空间。常数 PNG_MAX_PALETTE_LENGTH 的值是256 */
    palette = (png_colorp)png_malloc(png_ptr, PNG_MAX_PALETTE_LENGTH * sizeof(png_color));
 
    png_set_PLTE(png_ptr, info_ptr, palette, PNG_MAX_PALETTE_LENGTH);
 
       /* Write the file header information.  REQUIRED */
    png_write_info(png_ptr, info_ptr);
 
    /* The easiest way to write the image (you may have a different memory
    * layout, however, so choose what fits your needs best).  You need to
    * use the first method if you aren't handling interlacing yourself.
    */
    png_uint_32 k;
    png_byte *image;
    png_bytep row_pointers[height];
 
    image = pFrame->data[0];
 
    if (height > PNG_UINT_32_MAX/png_sizeof(png_bytep))
        png_error (png_ptr, "Image is too tall to process in memory");
 
    for (k = 0; k < height; k++)
        row_pointers[k] = image + k*width*3;
 
    /* One of the following output methods is REQUIRED */
    png_write_image(png_ptr, row_pointers);   
 
    //end，进行必要的扫尾工作：
    png_write_end(png_ptr, info_ptr);
    png_free(png_ptr, palette);
    png_destroy_write_struct(&png_ptr, &info_ptr);
 
    fclose(fp);   
    printf("success.\n");
    return ;
}