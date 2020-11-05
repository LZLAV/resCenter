clear all;
a = [1 -1.2357 2.9504 -3.1607 0.9106];  % AR模型
% AR模型频率响应
randn('state',1);
x = filter(1,a,randn(256,1));    % 输出AR模型
pyulear(x,4) ;
xlabel('频率/Hz');ylabel('相对功率谱密度(dB/Hz)');
title('用Yule-Walker AR法进行谱估计');
grid on
