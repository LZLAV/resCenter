function [b,a]=cas2dir(b0,B,A) 
%级联型到直接型的转换
%a=直接型分子多项式系数
%b=直接型分母多项式系数
%b0=增益系数
%B=包含各因子系数bk的K行3列矩阵
%A=包含各因子系数ak的K行3列矩阵
[K,L]=size(B);
b=[1]; 
a=[1];
for i=1:1:K
b=conv(b,B(i,:)); 
a=conv(a,A(i,:)); 
end 
b=b*b0;
其实现的MATLAB程序代码如下：
clear all
b0=3;
N=30;
B=[1,1,0;1,-3.1415926,1];
A=[1,-0.6,0;1,0.7,0.72];
delta=impseq(0,0,N);
x=[ones(1,5),zeros(1,N-5)];
[b,a]=cas2dir(b0,B,A) 
h=filter(b,a,delta);                %直接型单位脉冲响应
y=filter(b,a,x);                  % ?直接型输出响应
subplot(211);stem(h);
title('级联型h(n)');
subplot(212);stem(y);
title('级联型y(n)');
