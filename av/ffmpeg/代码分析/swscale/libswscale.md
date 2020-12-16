## Libswscale

Libswscale里面实现了各种图像像素格式的转换，例如YUV与RGB之间的转换；以及图像大小缩放（例如640x360拉伸为1280x720）功能。而且libswscale还做了相应指令集的优化，因此它的转换效率比自己写的C语言的转换效率高很多。

### 流程

Libswscale使用起来很方便，最主要的函数只有3个：

1. sws_getContext()：使用参数初始化SwsContext结构体。
2. sws_scale()：转换一帧图像
3.  sws_freeContext()：释放SwsContext结构体。

其中sws_getContext()也可以用另一个接口函数sws_getCachedContext()取代。

#### 复杂但是更灵活的初始化方式

初始化SwsContext除了调用sws_getContext()之外还有另一种方法，更加灵活，可以配置更多的参数。该方法调用的函数如下所示。

1. sws_alloc_context()：为SwsContext结构体分配内存。
2.  av_opt_set_XXX()：通过av_opt_set_int()，av_opt_set()…等等一系列方法设置SwsContext结构体的值。在这里需要注意，SwsContext结构体的定义看不到，所以不能对其中的成员变量直接进行赋值，必须通过av_opt_set()这类的API才能对其进行赋值。
3.  sws_init_context()：初始化SwsContext结构体。

这种复杂的方法可以配置一些sws_getContext()配置不了的参数。比如说设置图像的YUV像素的取值范围是**JPEG标准**（Y、U、V取值范围都是0-255）还是**MPEG标准**（Y取值范围是16-235，U、V的取值范围是16-240）。

### 概念

- 像素格式
- 图像拉伸
- YUV像素取值范围
- 色域

#### 像素格式

像素格式名称后面有“P”的，代表是planar格式，否则就是packed格式。Planar格式不同的分量分别存储在不同的数组中，例如AV_PIX_FMT_YUV420P存储方式如下：

> data[0]: Y1, Y2, Y3, Y4, Y5, Y6, Y7, Y8……
> data[1]: U1, U2, U3, U4……
> data[2]: V1, V2, V3, V4……

Packed格式的数据都存储在同一个数组中，例如AV_PIX_FMT_RGB24存储方式如下：

> data[0]: R1, G1, B1, R2, G2, B2, R3, G3, B3, R4, G4, B4……

FFmpeg有一个专门用于描述像素格式的结构体AVPixFmtDescriptor。

#### 图像拉伸

##### SWS_POINT

领域插值可以简单说成“1个点确定插值的点”。例如当图像放大后，新的样点根据距离它最近的样点的值取得自己的值。换句话说就是简单拷贝附近距离它最近的样点的值。领域插值是一种最基础的插值方法，速度最快，插值效果最不好，一般情况下不推荐使用。一般情况下使用邻域插值之后，画面会产生很多的“锯齿”。

##### SWS_BILINEAR(双线性插值)

双线性插值可以简单说成“4个点确定插值的点”。它的计算过程可以简单用下图表示。图中绿色的P点是需要插值的点。首先通过Q11，Q21求得R1；Q12，Q22求得R2。然后根据R1，R2求得P。

![img](./../png/SouthEast)

##### SWS_BICUBIC(双三次插值)

双三次插值可以简单说成“16个点确定插值的点”。该插值算法比前两种算法复杂很多，插值后图像的质量也是最好的。

#### YUV像素取值范围

FFmpeg中可以通过使用av_opt_set()设置“src_range”和“dst_range”来设置输入和输出的YUV的取值范围。如果“dst_range”字段设置为“1”的话，则代表输出的YUV的取值范围遵循“jpeg”标准；如果“dst_range”字段设置为“0”的话，则代表输出的YUV的取值范围遵循“mpeg”标准。

与RGB每个像素点的每个分量取值范围为0-255不同（每个分量占8bit），YUV取值范围有两种：

> 以Rec.601为代表（还包括BT.709 / BT.2020）的广播电视标准中，Y的取值范围是16-235，U、V的取值范围是16-240。FFmpeg中称之为“mpeg”范围。
>
> 以JPEG为代表的标准中，Y、U、V的取值范围都是0-255。FFmpeg中称之为“jpeg” 范围。

实际中最常见的是第1种取值范围的YUV（可以自己观察一下YUV的数据，会发现其中亮度分量没有取值为0、255这样的数值）。很多人在这个地方会有疑惑，为什么会去掉“两边”的取值呢？

在广播电视系统中不传输很低和很高的数值，实际上是为了防止信号变动造成过载，因而把这“两边”的数值作为“保护带”。

#### 色域





#### swscale()

swscale()是一行一行的进行图像缩放工作的。其中每行数据的处理按照“先水平拉伸，然后垂直拉伸”的方式进行处理。

1. 水平拉伸
   1. 亮度水平拉伸：hyscale()
   2. 色度水平拉伸：hcscale()

2. 垂直拉伸

   1. Planar

      1. 亮度垂直拉伸-不拉伸：yuv2plane1()

      2. 亮度垂直拉伸-拉伸：yuv2planeX()

      3. 色度垂直拉伸-不拉伸：yuv2plane1()

      4. 色度垂直拉伸-拉伸：yuv2planeX()
2. Packed
      1. 垂直拉伸-不拉伸：yuv2packed1()
      2. 垂直拉伸-拉伸：yuv2packedX()





#### hyscale()

**1.转换成Y（亮度）**
如果SwsContext的toYV12()函数存在，调用用该函数将数据转换为Y。如果该函数不存在，则调用SwsContext的readLumPlanar()读取Y。
**2.拉伸**
拉伸通过SwsContext的hyScale ()函数完成。如果存在hyscale_fast()方法的话，系统会优先调用hyscale_fast()。
**3.转换范围（如果需要的话）**
如果需要转换亮度的取值范围（例如需要进行16-235的MPEG标准与0-255的JPEG标准之间的转换），则会调用SwsContext的lumConvertRange ()函数。

#### hcscale()

水平色度拉伸函数hcscale()

**1.转换成UV**该功能通过SwsContext的chrToYV12 ()函数完成。如果该函数不存在，则调用SwsContext的readChrPlanar ()读取UV。

**2.拉伸**
拉伸通过SwsContext的hcScale ()函数完成。如果存在hcscale_fast()方法的话，系统会优先调用hcscale_fast ()。

**3.转换范围（如果需要的话）**
如果需要转换色度的取值范围（例如色度取值范围从0-255转换为16-240），则会调用SwsContext的chrConvertRange ()函数。