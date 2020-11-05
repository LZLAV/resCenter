clear all;
N=1200; Fs=600;         %数据长度和采样频率
n=0:N-1; t=n/Fs;        %时间序列
Lag=100;                %延迟样点数
randn('state',0);       %设置产生随机数的初始状态
x=cos(2*pi*10*t)+0.7*randn(1,length(t));  %原始信号
[c,lags]=xcorr(x,Lag,'unbiased');  %对原始信号进行无偏自相关估计
subplot(2,2,1); plot(t,x);       %绘制原始信号x
xlabel('时间/s'); ylabel('x(t)'); 
title('带噪声周期信号');
grid on;
subplot(2,2,2);plot(lags/Fs,c);   %绘制x信号自相关,lags/Fs为时间序列
xlabel('时间/s'); ylabel('Rx(t)');
title('带噪声周期信号的自相关');
grid on;
% 信号x1
x1=randn(1,length(x));        %产生一与x长度一致的随机信号
[c,lags]=xcorr(x1,Lag,'unbiased');  %求随机信号x1的无偏自相关
subplot(2,2,3); plot(t,x1);  %绘制随机信号x1
xlabel('时间/s'); ylabel('x1(t)');
title('噪声信号');
grid on;
subplot(2,2,4); plot(lags/Fs,c);     %绘制随机信号x1的无偏自相关
xlabel('时间/s'); ylabel('Rx1(t)');
title('噪声信号的自相关');
grid on
