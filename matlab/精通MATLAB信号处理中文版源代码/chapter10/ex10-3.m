clear
fs=22050;                  %语音信号采样频率为22050
[x,fs,bits]=wavread('qq.wav');  
sound(x,fs,bits);           %播放语音信号
y1=fft(x,1024);           %对信号做1024点FFT变换
f=fs*(0:511)/1024;
figure(1)
plot(x)                   %做原始语音信号的时域波形图
title('原始语音信号时域图');
xlabel('时间');
ylabel('幅值');
figure(2)
freqz(x)                  %绘制原始语音信号的频率响应图
title('频率响应图')
figure(3)
plot(f,abs(y1(1:512)));
title('原始语音信号频谱')
xlabel('频率');
ylabel('幅度');
