function [Hr,w,a,L]=hr_type1(h);
%计算所设计的1型滤波器的振幅响应
%Hr=振幅响应
%a=1型滤波器的系数
%L=Hr的阶次
%h=1型滤波器的单位冲击响应
M=length(h);
L=(M-1)/2;
a=[h(L+1) 2*h(L:-1:1)];
n=[0:1:L];
w=[0:1:500]'*2*pi/500;
Hr=cos(w*n)*a';
