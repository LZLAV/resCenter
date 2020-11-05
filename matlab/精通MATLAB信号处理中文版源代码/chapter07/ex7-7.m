clf;
Fs=2000;
N=512;Nfft=512;
%数据的长度和FFT所用的数据长度
n=0:N-1;t=n/Fs;
%采用的时间序列
xn=sin(2*pi*50*t)+2*sin(2*pi*120*t)+randn(1,N);
Pxx=10*log10(abs(fft(xn,Nfft).^2)/N);
%Fourier振幅谱平方的平均值，并转化为dB
f=(0:length(Pxx)-1)*Fs/length(Pxx);
%给出频率序列
subplot(2,1,1),plot(f,Pxx);
%绘制功率谱曲线
xlabel('频率/Hz');ylabel('功率谱/dB');
title('周期图 N=512');
grid on;
Fs=1000;
N=1024;Nfft=1024;
%数据的长度和FFT所用的数据长度
n=0:N-1;t=n/Fs;
%采用的时间序列
xn=sin(2*pi*50*t)+2*sin(2*pi*120*t)+randn(1,N);
Pxx=10*log10(abs(fft(xn,Nfft).^2)/N);
%Fourier振幅谱平方的平均值，并转化为dB
f=(0:length(Pxx)-1)*Fs/length(Pxx);
%给出频率序列
subplot(2,1,2),plot(f,Pxx);
%绘制功率谱曲线
xlabel('频率/Hz');ylabel('功率谱/dB');
title('周期图 N=1024');
grid on;
