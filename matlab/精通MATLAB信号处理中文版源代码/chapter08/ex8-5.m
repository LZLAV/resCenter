clear all;
load sumsin;       %装载原始sumsin信号
s=sumsin(1:500); 
% 取信号的前500个采样点
[c,l] = wavedec(s,3,'db1'); 
subplot(311); plot(s); 
title('原始sumsin信号'); 
subplot(312); plot(c); 
title('小波3层重构') 
xlabel(['尺度3的低频系数和尺度3,2,1的高频系数'])
% 获得尺度2的小波分解
[nc,nl] = upwlev(c,l,'db1'); 
subplot(313); plot(nc); 
title('小波2层重构') 
xlabel(['尺度2的低频系数和尺度2,1的高频系数'])
