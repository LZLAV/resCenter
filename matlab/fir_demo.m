% fir 滤波器示例
clear;
close all;
clc;

%直接型
%{
n = 0:10;
N = 30;
b = 0.9.^n;
delta = impseq(0,0,N);
h = filter(b,1,delta);
x = [ones(1,5),zeros(1,N-5)];
y = filter(b,1,x);
subplot(2,2,1);
stem(h);
title('直接型h(n)');
subplot(2,2,2);stem(y);
title('直接型y(n)');
[b0,B,A] = dir2cas(b,1);
h = casfilter(b0,B,A,delta);
y = casfilter(b0,B,A,x);
subplot(2,2,3);stem(h);
title('级联型');
subplot(2,2,4);stem(y);
title('级联型y(n)');
%}

% 利用频率采样发设计一个低通FIR 数字低通滤波器，其理想频率特性是矩形的，给定采样频率为 2*pi%1.5*10^4
% 截止频率为 2*pi*1.6*10^3 ,阻带起始频率为 2*pi*3.1*10^3，通带波动 <= 1dB,阻带衰减 >= 50dB
%{
N = 30;
H = [ones(1,4),zeros(1,22),ones(1,4)];
H(1,5) = 0.5886;
H(1,26)=0.5886;
H(1,6) = 0.1065;
H(1,25) = 0.1065;
k = 0:(N/2-1);k1 = (N/2+1):(N-1);k2 =0;
A = [exp(-j*pi*k*(N-1)/N),exp(-j*pi*k2*(N-1)/N),exp(j*pi*(N-k1)*(N-1)/N)];
HK = H.*A;
h = ifft(HK);
fs = 15000;
[c,f3] = freqz(h,1); 
f3 = f3/pi *fs/2;
subplot(221);
plot(f3,20*log10(abs(c)));
title('频谱特性');
xlabel('频率/Hz');ylabel('衰减/dB');
grid on;
subplot(222);
title('输入采样波形');
stem(real(h),'.');
line([0,35],[0,0]);
xlabel('n');
ylabel('Real(h(n))');
grid on;
t = (0:100)/fs;
W = sin(2*pi*t*750) + sin(2*pi*t*3000)+sin(2*pi*t*6500);
q = filter(h,1,W);
[a,f1] = freqz(W);
f1 = f1/pi*fs/2;
[b,f2] = freqz(q);
f2 = f2/pi*fs/2;
subplot(223);
plot(f1,abs(a));
title('输入波形频谱图');
xlabel('频率');
ylabel('幅度');
grid on;
subplot(224);
plot(f2,abs(b));
title('输出波形频谱图');
xlabel('频率');
ylabel('幅度');
grid on;
%}

% 一个 20点相位 FIR 系统的频率样本的频率采样型结构
%{
M = 20;
alpha = (M-1)/2;
magHK = [1 1 1 0.5 zeros(1,13) 0.5 1 1];
k1 = 0:10;
k2 = 11:M-1;
angHK = [-alpha*2*pi/M*k1,alpha*2*pi/M*(M-k2)];
H = magHK.*exp(j*angHK);
h = real(ifft(H,M));
[C,B,A] = dir2fs(h)
%}




