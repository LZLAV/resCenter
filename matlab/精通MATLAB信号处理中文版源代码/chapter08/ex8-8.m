clear all;
load whitnois;   %装载原始whitnois信号
x = whitnois;
% 使用db1小波包对信号x进行3层分解
t = wpdec(x,3,'db1','shannon');
subplot(2,1,1);plot(x)
title('原始whitnois信号');
% 重构小波包结点(2,1)
rcfs = wprcoef(t,[2 1]);
subplot(212); plot(rcfs); 
title('重构小波包结点(2,1)');
