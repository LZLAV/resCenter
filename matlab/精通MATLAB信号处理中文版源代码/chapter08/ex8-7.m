clear all;
load sumsin;       %% 装载原始sumsin信号
s=sumsin(1:500); 
% 取信号的前500个采样点
% 使用Shannon熵
wpt=wpdec(s,3,'db2','shannon');
% 对信号进行重构
rex=wprec(wpt);
subplot(211); plot(s); 
title('原始sumsin信号'); 
subplot(212); plot(rex); 
title('重构后的信号');
