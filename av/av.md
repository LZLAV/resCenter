# av



## 服务器体系结构

- Mesh 方案，即多个终端之间两两进行连接，形成一个网状结构。比如 A、B、C 三个终端进行多对多通信，当 A 想要共享媒体（比如音频、视频）时，它需要分别向 B 和 C 发送数据。同样的道理，B 想要共享媒体，就需要分别向 A、C 发送数据，依次类推。这种方案对各终端的带宽要求比较高。
- MCU（Multipoint Conferencing Unit）方案，该方案由一个服务器和多个终端组成一个星形结构。各终端将自己要共享的音视频流发送给服务器，服务器端会将在同一个房间中的所有终端的音视频流进行混合，最终生成一个混合后的音视频流再发给各个终端，这样各终端就可以看到 / 听到其他终端的音视频了。实际上服务器端就是一个音视频混合器，这种方案服务器的压力会非常大。
- SFU（Selective Forwarding Unit）方案，该方案也是由一个服务器和多个终端组成，但与 MCU 不同的是，SFU 不对音视频进行混流，收到某个终端共享的音视频流后，就直接将该音视频流转发给房间内的其他终端。它实际上就是一个音视频路由转发器。

### 工具

#### PSNR 和 SSIM

- MSU Video Quality Measurement Tool



#### 音频SNR

- CompAudio

#### 视频质量评价工具

- Evalvid

#### 网络模拟工具

- Network Simulator

#### 可视化在线视频监测

- Youbora
- Conviva
- Touchstone

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