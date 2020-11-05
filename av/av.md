# av

### 时钟频率

通常视频的时钟频率为 90000，音频的时钟频率为 8000。对应时间戳可如下方式计算：

RTP timestamp是用时钟频率（clock rate）计算而来表示时间的。
RTP timestamp表示每帧的时间，由于一个帧（如I帧）可能被分成多个RTP包，所以多个相同帧的RTP timestamp相等。（可以通过每帧最后一个RTP的marker标志区别帧，但最可靠的方法是查看相同RTP timestamp包为同一帧。）

> 两帧之间RTP timestamp的增量 = 时钟频率 / 帧率
>

 其中时钟频率可从SDP中获取，如:

> m=video 2834 RTP/AVP 96
> a=rtpmap:96 H264/90000

其时钟频率为90000（通常视频的时钟频率），若视频帧率为25fps，则相邻帧间RTP timestamp增量值 = 90000/25 = 3600。







#### 资源

《WebRTC 音视频开发 React+ Flutter+ Go 实践》

​	源代码：https://github.com/kangshaojun

​	http://www.kangshaojun.com

​	

《MATLAB 》

​	源代码：http://blog.sina.com.cn/caxart



《MATLAB 面向对象和 C/C++编程》

​	资料下载：http://pan.baidu.com/s/1S-7HTXpxZIOgvLxWmIMS6Q



《WebRTC Native 开发实践》

​	源代码：https://github.com/HackWebRTC/webrtc



《语音信号处理》

​	课件下载：http://www.tup.com.cn



《音视频开发进阶指南》

​	源代码：https://github.com/zhanxiaokai



《FFmpeg 从入门到精通》

​	书中示例代码：https://ffmpeg.org/doxygen/trunk/examples.html

​	FFmpeg 官方文档：http://ffmpeg.org/documentation.html

​	FFmpeg官方wiki: https://trac.ffmpeg.org

中文经典资料

​	雷晓骅博士总结的资料：http://blog.csdn.net/leixiaohua1020

​	罗索实验室：http://www.rosoo.net

​	ChinaFFmpeg: http://bbs.chinaffmpeg.com



《OpenCV Android 开发实践》

​	源代码：https://github.com/gloomyfish1998/opencv4android/tree/master/samples/OpencvDemo

​	参考资料：https://github.com/gloommyfish1998/opencv4android



《深入OpenCV Android 应用开发》

​	源代码：http://www.broadview.com.cn  下载专区



《Android音视频开发》

​	源代码：https://github.com/hejunlin2013/AVBookCode



《OpenGL ES 应用开发实践指南》

​	源代码：http://pragprog.com/book/kbogla

​	LearnOpenGL 中文网站：https://learnopengl-cn.github.io/