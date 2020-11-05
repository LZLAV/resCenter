clear all;
Fs=1000;          %采样频率
NFFT=1024;
t=0:1/Fs:1;       %时间序列
x=sin(2*pi*100*t)+sin(2*pi*200*t)+sin(2*pi*400*t)+randn(size(t));  %信号
window1=boxcar(100);
window2=hamming(100);
noverlap=20;         %指定段与段之间的重叠的样本数
[pxx1,f1]=pwelch(x,window1,noverlap,NFFT,Fs);
[pxx2,f2]=pwelch(x,window2,noverlap,NFFT,Fs);
pxx1=10*log10(pxx1);
pxx2=10*log10(pxx2);
subplot(211);plot(f1,pxx1);
title('矩形窗');
subplot(212);plot(f2,pxx2);
title('海明窗');
