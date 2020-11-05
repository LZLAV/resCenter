function y=parfiltr(C,B,A,x)
%IIR滤波器的并型实现
% y= parfiltr(C,B,A,x)
%y为输出
%C为当B的长度等于A的长度时多项式的部分
%B=包含各因子系数bk的K行2维实系数矩阵
%A=包含各因子系数ak的K行3维实系数矩阵
%x为输入
 [K,L]=size(B);
N=length(x);
w=zeros(K+1,N);
w(1,:)=filter(C,1,x);
for i=1:1:K
    w(i+1,:)=filter(B(i,:),A(i,:),x);
end
y=sum(w);
其实现的MATLAB程序代码如下：
clear
C=0;
N=30;
B=[-13.65,-14.81;32.60,16.37];
A=[1,-2.95,3.14;1,-1,0.5];
delta=impseq(0,0,N);
x=[ones(1,5),zeros(1,N-5)];
h=parfiltr(C,B,A,delta);			%并联型单位脉冲响应，delta指的是增量，差值
y=parfiltr(C,B,A,x);			%并联型输出响应
subplot(211);stem(h);
title('并联型h(n)');
subplot(212);stem(y);
title('并联型y(n)');
