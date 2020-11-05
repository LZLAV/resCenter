function [b,a]=par2dir(C,B,A)
%并联模型到直接型的转换
% [b,a]=par2dir(C,B,A)
% C为当b的长度大于a时的多项式部分
% B为包含各bk的K乘二维实系数矩阵
% A为包含各ak的K乘三维实系数矩阵
% b为直接型分子多项式系数
% a为直接型分母多项式系数
[K,L]=size(A);
R=[];
P=[];
for i=1:1:K
    [r,p,k]=residuez(B(i,:),A(i,:));
    R=[R;r];
    P=[P;p];
end
[b,a]=residuez(R,P,C);
b=b(:)';
a=a(:)';
其实现的MATLAB程序代码如下：
clear all;
C=0;B=[-13.65 -14.81;32.60 16.37];
A=[1,-2.95,3.14;1,-1,0.5];N=60;
delta=impseq(0,0,N);
[b,a]=par2dir(C,B,A);
h=filter(b,a,delta);
x=[ones(1,5),zeros(1,N-5)];
y=filter(b,a,x);
subplot(211);stem(h);
xlabel('(a) 直接型h(n)');
subplot(212);stem(y);
xlabel('(a) 直接型y(n)');
