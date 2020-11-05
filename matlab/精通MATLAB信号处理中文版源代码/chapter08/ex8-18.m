clc;
clear all;
snr=4;                                        %设置信噪比
%MATLAB中用''wnoise''产生测试信号
%原始信号为xref，含高斯白噪声的信号为x
%信号类型为blocks（由函数中参数1决定）
%长度均为2^11（由函数中的参数11决定）
%信噪比snr=4（由函数中的参数snr决定）
 [xref,x]=wnoise(1,11,snr);
xref=xref(1:2000);                            %取信号的前2000点
x=x(1:2000);                                %取信号的前2000点
%用全局默认阈值进行去噪处理
 [thr,sorh,keepapp]=ddencmp('den','wv',x);         % 获取全局默认阈值
xd=wdencmp('gbl',x,'sym8',3,thr,sorh,keepapp);    %利用全局默认阈值对信号去噪
%下面是作图函数，作出原始信号和含噪声信号的图
figure
subplot(231);plot(xref);                 %画出原始信号的图
title('原始信号');
subplot(234);plot(x);
title('含噪声信号');                    %画出含噪声信号的图
%下面用傅里叶变换进行原信号和噪声信号的频谱分析
dt=1/(2^11);                         %时域分辨率
Fs=1/dt;                            %计算频域分辨率
df=Fs/2000;                         
xxref=fft(xref);                      %对原始信号做快速傅里叶变换
xxref=fftshift(xxref);                 %将频谱图平移
xxref=abs(xxref);                    %取傅里叶变换的幅值
xx=fft(x);                          %对含噪声信号做快速傅里叶变换
xx=fftshift(xx);                      %将频谱搬移
absxx=abs(xx);                      %取傅里叶变换的幅值
ff=-1000*df:df:1000*df-df;            %设置频率轴
subplot(232);plot(ff,xxref);            %画出原始信号的频谱图
title('原始信号的频谱图');
subplot(235);plot(ff,absxx);
title('含信号噪声的频谱图');          %画出含噪声信号的频谱图
%进行低通滤波，滤波频率为0~200的相对频率
indd2=1:800;                      %0频左边高频率系数置零
xx(indd2)=zeros(size(indd2));
indd2=1201:2000;
xx(indd2)=zeros(size(indd2));        %0频右边高频系数置零
xden=ifft(xx);                     %滤波后的信号作傅里叶逆变换
xden=abs(xden);                   %取幅值
subplot(233);plot(xd);               %画出小波去除噪后的信号
title('小波去除噪后的信号');
subplot(236);plot(xden);             %画出傅里叶分析去噪的信号
title('傅里叶分析去噪的信号');
