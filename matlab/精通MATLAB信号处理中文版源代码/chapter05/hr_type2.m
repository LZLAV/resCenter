function [Hr,w,b,L]=hr_type2(h); 
%计算所设计的2型滤波器的振幅响应
%Hr=振幅响应
%b=2型滤波器的系数
%L=Hr的阶次
%h=2型滤波器的单位冲击响应
M=length(h);
L=M/2;
b= 2*h(L:-1:1);
n=[1:1:L];
n=n-0.5;
w=[0:1:500]'*2*pi/500;
Hr=cos(w*n)*b';
