clear all;
Fs=2000;             %频率
t=0:1/Fs:1-1/Fs;     %时间序列
x=5*sin(2*pi*200*t)+5*cos(2*pi*202*t)+randn(1,length(t));
NFFT=1024;
p=40;
pxx=pmusic(x,p,NFFT,Fs);    %MUSIC估计
k=0:floor(NFFT/2-1);
figure;
subplot(211);plot(k*Fs/NFFT,10*log10(pxx(k+1)));
xlabel('频率/Hz');ylabel('相对功率谱密度(dB/Hz)');
title('MUSIC法谱估计');
pxx1=peig(x,p,NFFT,Fs);   %特征向量估计
k=0:floor(NFFT/2-1);
subplot(212);plot(k*Fs/NFFT,10*log10(pxx1(k+1)));
xlabel('频率/Hz');ylabel('相对功率谱密度(dB/Hz)');
title('特征向量法谱估计');
