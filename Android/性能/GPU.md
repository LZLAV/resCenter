GPU

GPU流程示意图

![](./png/GPU.jpg)

GPU全称是Graphic Processing Unit－－图形处理器，其最大的作用就是进行各种绘制计算机图形所需的运算，包括顶点设置、光影、像素操作等。GPU实际上是一组图形函数的集合，而这些函数由硬件实现。以前，这些工作都是有CPU配合特定软件进行的，GPU从某种意义上讲就是为了在图形处理过程中充当主角而出现的。



一个简单的GPU结构示意图包含一块标准的GPU主要包括2D Engine、3D Engine、VideoProcessing Engine、FSAA Engine、显存管理单元等。其中，3D运算中起决定作用的是3DEngine，这是现代3D显卡的灵魂，也是区别GPU等级的重要标志。



GPU  工作原理

**GPU的图形（处理）流水线完成如下的工作：（并不一定是按照如下顺序）**

**顶点处理：**这阶段GPU读取描述3D图形外观的顶点数据并根据顶点数据确定3D图形的形状及位置关系，建立起3D图形的骨架。在支持DX系列规格的GPU中，这些工作由硬件实现的Vertex Shader（定点着色器）完成。



**光栅化计算：**显示器实际显示的图像是由像素组成的，我们需要将上面生成的图形上的点和线通过一定的算法转换到相应的像素点。把一个矢量图形转换为一系列像素点的过程就称为光栅化。例如，一条数学表示的斜线段，最终被转化成阶梯状的连续像素点。



**纹理帖图：**顶点单元生成的多边形只构成了3D物体的轮廓，而纹理映射（texture mapping）工作完成对多变形表面的帖图，通俗的说，就是将多边形的表面贴上相应的图片，从而生成“真实”的图形。TMU（Texture mapping unit）即是用来完成此项工作。



**像素处理：**这阶段（在对每个像素进行光栅化处理期间）GPU完成对像素的计算和处理，从而确定每个像素的最终属性。在支持DX8和DX9规格的GPU中，这些工作由硬件实现的Pixel Shader（像素着色器）完成。



**最终输出：**由ROP（光栅化引擎）最终完成像素的输出，1帧渲染完毕后，被送到显存帧缓冲区。

**总结：**GPU的工作通俗的来说就是完成3D图形的生成，将图形映射到相应的像素点上，对每个像素进行计算确定最终颜色并完成输出。



**CPU与GPU的数据处理关系**

如今的显卡图形，单单从图象的生成来说大概需要下面四个步骤：

1、Homogeneouscoordinates（齐次坐标）

2、Shadingmodels（阴影建模）

3、Z-Buffering（Z-缓冲）

4、Texture-Mapping（材质贴图）

在这些步骤中，显示部分（GPU）只负责完成第三、四步，而前两个步骤主要是依靠 CPU 来完成。而且，这还仅仅只是3D图象的生成，还没有包括图形中复杂的AI运算。场景切换运算等等……无疑，这些元素还需要CPU去完成。



**CPU和GPU之间的数据交互**

首先从硬盘中读取模型， CPU分类后将多边形信息交给GPU，GPU再时时处理成屏幕上可见的多边形，但是没有纹理只有线框。

模型出来后，GPU将模型数据放进显存，显卡同时也为模型贴材质，给模型上颜色。CPU相应从显存中获取多边形的信息。然后CPU计算光照后产生的影子的轮廓。等CPU计算出后，显卡的工作又有了，那就是为影子中填充深的颜色

这一点要注意的是，无论多牛的显卡，光影都是CPU计算的，GPU只有2个工作，1多边形生成。2为多边形上颜色。





#### adb 采集GPU占用率，目前支持高通GPU芯片（Qualcomm  Adreno系列）

直接apk内读取文件即可，不需要shell权限（支持到Android8）
 Gpu使用率获取：会得到两个值，（前一个/后一个）*100%=使用率
 adb shell cat   /sys/class/kgsl/kgsl-3d0/gpubusy

Gpu工作频率：
 adb shell cat   /sys/class/kgsl/kgsl-3d0/gpuclk
 adb shell cat   /sys/class/kgsl/kgsl-3d0/devfreq/cur_freq

Gpu最大、最小工作频率：
 adb shell cat  /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
 adb shell cat  /sys/class/kgsl/kgsl-3d0/devfreq/min_freq

Gpu可用频率
 adb shell cat   /sys/class/kgsl/kgsl-3d0/gpu_available_frequencies
 adb shell cat   /sys/class/kgsl/kgsl-3d0/devfreq/available_frequencies

Gpu可用工作模式：
 adb shell cat   /sys/class/kgsl/kgsl-3d0/devfreq/available_governors

Gpu当前工作模式：
 adb shell cat    /sys/class/kgsl/kgsl-3d0/devfreq/governor