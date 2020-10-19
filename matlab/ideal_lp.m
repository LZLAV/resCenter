function hd = ideal_lp(wc,M)
% 计算理想低通滤波器的冲激响应
%[hd] = ideal_lp(wc,M)
% hd = 理想冲激响应 0 到M-1
% wc = 截止频率
% M = 理想滤波器的长度
alpha = (M -1)/2;
n  =[0:1:(M-1)];
m = n-alpha+eps;
% 加上一个很小的值 eps 避免除以 0 的错误情况出现
hd = sin(wc*m) ./(pi*m);