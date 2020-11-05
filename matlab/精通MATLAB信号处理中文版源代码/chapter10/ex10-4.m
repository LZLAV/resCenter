fs=22050;                  %语音信号采样频率为22050
[x,fs,bits]=wavread('qq.wav'); %读取语音信号的数据，赋给变量x
%sound(x)
%t=0:1/22050:(size(x)-1)/22050;
y1=fft(x,1024);           %对信号做1024点FFT变换
f=fs*(0:511)/1024;
x1=rand(1,length(x))';   %产生一与x长度一致的随机信号  
x2=x1+x;
%t=0:(size(x)-1);        %加入正弦噪音
%Au=0.3;
%d=[Au*sin(6*pi*5000*t)]';
%x2=x+d; 
sound(x2);
figure(1)
subplot(2,1,1)
plot(x)                   %做原始语音信号的时域图形
title('原语音信号时域图')
subplot(2,1,2)
plot(x2)                   %做原始语音信号的时域图形
title('加高斯噪声后语音信号时域图')
xlabel('时间');
ylabel('幅度');
y2=fft(x2,1024);
figure(2)
subplot(2,1,1)
plot(abs(y1))
title('原始语音信号频谱');
xlabel('Hz');
ylabel('fudu');
subplot(2,1,2)
plot(abs(y2))
title('加噪语音信号频谱');
xlabel('频率');
ylabel('幅度');
