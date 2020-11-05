clear all;
fs=200;          %采样频率
N=128;            %数据个数
n=0:N-1;
t=n/fs;          %数据对应的时间序列
x=0.5*sin(2*pi*20*t)+2*sin(2*pi*60*t);       %时间域信号
subplot(2,2,1);plot(t,x);
xlabel('时间/s');ylabel('x');
title('原始信号');
grid on;

y=fft(x,N);   %傅里叶变换
mag=abs(y);   %得到振幅谱
f=n*fs/N;     %频率序列
subplot(2,2,2);plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');ylabel('振幅');
title('原始信号的FFT');
grid on;

xifft=ifft(y);      %进行傅里叶逆变换
realx=real(xifft);   %求取傅里叶逆变换的实部
ti=[0:length(xifft)-1]/fs;  %傅里叶逆变换的时间序列
subplot(2,2,3);plot(ti,realx);
xlabel('时间/s');ylabel('x');
title('运用傅里叶逆变换得到的信号');
grid on;

yif=fft(xifft,N);   %将傅里叶逆变换得到的时间域信号进行傅里叶变换
mag=abs(yif);
f=[0:length(y)-1]'*fs/length(y);    %频率序列
subplot(2,2,4);plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');ylabel('振幅');
title('运用IFFT得到信号的快速傅里叶变换');
grid on;
