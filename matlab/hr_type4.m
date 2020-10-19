% IV型滤波器的幅度响应如下
function[Hr,w,d,L] = hr_type4(h)
% 计算所设计的IV 型滤波器的振幅响应
% Hr = 振幅响应
% d = 4 型滤波器的系数
% L = Hr 的阶次
% h = 4型滤波器的单位冲激响应
M  = length(h);
L = M/2;
d = 2*[h(L:-1:1)];
n = [1:1:L];
n = n-0.5;
w = [0:1:500]'*2*pi/500;
Hr = sin(w*n)*d';