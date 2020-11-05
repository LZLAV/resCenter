function [C,B,A] = dir2fs(h)
% 直接型到频率采样型的转换
% [C,B,A] = dir2fs(h)
% C = 包含各并行部分增益的行向量
% B = 包含按行排列的分子系数矩阵
% A = 包含按行排列的分母系数矩阵
% h =  FIR滤波器的脉冲响应向量
M = length(h);
H = fft(h,M);
magH = abs(H); phaH = angle(H)';
% check even or odd M
if (M == 2*floor(M/2))
      L = M/2-1;   %  M为偶数 
     A1 = [1,-1,0;1,1,0];
     C1 = [real(H(1)),real(H(L+2))];
 else
      L = (M-1)/2; % M is odd
     A1 = [1,-1,0];
     C1 = [real(H(1))];
 end
k = [1:L]';
% 初始化 B 和 A 数组
B = zeros(L,2); A = ones(L,3);
% 计算分母系数
A(1:L,2) = -2*cos(2*pi*k/M); A = [A;A1];
% 计算分子系数
B(1:L,1) = cos(phaH(2:L+1));
B(1:L,2) = -cos(phaH(2:L+1)-(2*pi*k/M));
% 计算增益系数
C = [2*magH(2:L+1),C1]';
close all;
clear;
N=30;
H=[ones(1,4),zeros(1,22),ones(1,4)];
H(1,5)=0.5886;H(1,26)=0.5886;H(1,6)=0.1065;H(1,25)=0.1065;
k=0:(N/2-1);k1=(N/2+1):(N-1);k2=0;
A=[exp(-j*pi*k*(N-1)/N),exp(-j*pi*k2*(N-1)/N),exp(j*pi*(N-k1)*(N-1)/N)];
HK=H.*A;
h=ifft(HK);
fs=15000;
[c,f3]=freqz(h,1);
f3=f3/pi*fs/2;
subplot(221);
plot(f3,20*log10(abs(c)));
title('频谱特性');
xlabel('频率/HZ');ylabel('衰减/dB');
grid on;
subplot(222);
title('输入采样波形');
stem(real(h),'.');
line([0,35],[0,0]);
xlabel('n');ylabel('Real(h(n))');
grid on;
t=(0:100)/fs;
W=sin(2*pi*t*750)+sin(2*pi*t*3000)+sin(2*pi*t*6500);
q=filter(h,1,W);
[a,f1]=freqz(W);
f1=f1/pi*fs/2;
[b,f2]=freqz(q);
f2=f2/pi*fs/2;
subplot(223);
plot(f1,abs(a));
title('输入波形频谱图');
xlabel('频率');ylabel('幅度')
grid on;
subplot(224);
plot(f2,abs(b));
title('输出波形频谱图');
xlabel('频率');ylabel('幅度')
grid on;
