clear;
clc;
t = 0:.001:.25;     %250个采样点
x = sin(2*pi*50*t) + sin(2*pi*120*t);
y = x;       %添加随机噪声
figure(1);
plot(y(1:50));          %绘制图形，横坐标为 1-50
title('Noisy time domain signal');
Y = fft(y,251);         %傅里叶变化，时域变换成频域
figure(2)
stem(abs(Y));
Pyy = Y.*conj(Y)/251;   %conj 计算功率谱密度
f = 1000/251*(0:127);
figure(3);
stem(f,Pyy(1:128));
title('Power spectral density');
xlabel('Frequency (Hz)');
figure(4);
stem(f(1:50),Pyy(1:50));
title('Power spectral density');
xlabel('Frequency (Hz)')