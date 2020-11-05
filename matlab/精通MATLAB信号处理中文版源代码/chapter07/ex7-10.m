clear all;
randn('state',0 );       %设置噪声的初始状态
Fs = 2000;              %采样频率
t = 0:1/Fs:.3;          %时间序列
% 输入信号
x = sin(2*pi*t*200) + randn(size(t));   
pwelch(x,33,32,[],Fs,'twosided');
xlabel('频率/Hz');
title('利用pwelch函数实现功率谱估计');
