clear all;
load leleccum;     %装载原始leleccum信号
s=leleccum(1:540);
% 用小波函数db1对信号进行三尺度小波分解
[C,L]=wavedec(s,3,'db1');
subplot(2,1,1);plot(s);
title('原始信号');
% 用小波函数db1进行信号的低频重构
a3=wrcoef('a',C,L,'db1');
subplot(2,1,2);plot(a3);
title('小波重构信号');
