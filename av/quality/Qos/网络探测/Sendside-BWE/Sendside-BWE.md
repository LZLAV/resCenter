## Sendside-BWE

M55 版本引进 Sendside-BWE 拥塞控制算法，把所有码率计算都移到发送端进行，并采用全新的 Trendline 滤波器取代之前的 Kalman 滤波器。能够更好更快的进行码率估计和网络过载恢复。

RTP头部扩展 TransportSequenceNumber ，代表传输序号（不同于媒体层序号，用于组帧和抗丢包），关注数据传输特性，用于码率估计。

接收端，通过检查头部是否有 TransportSequenceNumber 扩展，决定采用 Sendside-BWE 还是 GCC 算法。接收端的 EstimatorProxy 周期发送 Transport-CC 报文。

包括关键技术：包组延迟评估（InterArrival）、滤波器趋势判断（TrendlineEstimator）、过载检测（OveruseDetector）和码率调节（AimdRateControl）。

