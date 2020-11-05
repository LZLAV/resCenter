clear all;
fs=100;          %采样频率
Ndata=32;        %数据长度
N=32;            %FFT的数据长度
n=0:Ndata-1;
t=n/fs;          %数据对应的时间序列
x=0.5*sin(2*pi*20*t)+2*sin(2*pi*60*t);       %时间域信号
y=fft(x,N);        %信号的傅里叶变换
mag=abs(y);        %求取振幅
f=(0:N-1)*fs/N;    %真实频率
subplot(2,2,1);plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');ylabel('振幅');
title('Ndata=32; FFT所以采点个数=32');
grid on;

Ndata=32;        %数据长度
N=128;           %FFT采用的数据长度
n=0:Ndata-1;
t=n/fs;          %时间序列
x=0.5*sin(2*pi*20*t)+2*sin(2*pi*60*t);       %时间域信号
y=fft(x,N);
mag=abs(y);
f=(0:N-1)*fs/N;    %真实频率
subplot(2,2,2);plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');ylabel('振幅');
title('Ndata=32; FFT所以采点个数=128');
grid on;

Ndata=136;        %数据长度
N=128;           %FFT采用的数据长度
n=0:Ndata-1;
t=n/fs;          %时间序列
x=0.5*sin(2*pi*20*t)+2*sin(2*pi*60*t);       %时间域信号
y=fft(x,N);
mag=abs(y);
f=(0:N-1)*fs/N;    %真实频率
subplot(2,2,3);plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');ylabel('振幅');
title('Ndata=136; FFT所以采点个数=128');
grid on;

Ndata=136;        %数据长度
N=512;           %FFT采用的数据长度
n=0:Ndata-1;
t=n/fs;          %时间序列
x=0.5*sin(2*pi*20*t)+2*sin(2*pi*60*t);       %时间域信号
y=fft(x,N);
mag=abs(y);
f=(0:N-1)*fs/N;    %真实频率
subplot(2,2,4);plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');ylabel('振幅');
title('Ndata=136; FFT所以采点个数=512');
grid on;
