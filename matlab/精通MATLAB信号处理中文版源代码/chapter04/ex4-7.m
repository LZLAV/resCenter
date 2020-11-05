function [C,B,A]=dir2par(b,a)
%直接型结构转换为并联型
% [C,B,A]=dir2par(b,a)
%C为当b的长度等于a的长度时多项式的部分
%B=包含各因子系数bk的K行2维实系数矩阵
%A=包含各因子系数ak的K行3维实系数矩阵
%b=直接型分子多项式系数
%a=直接型分母多项式系数
M=length(b);
N=length(a);
[r1,p1,C]=residuez(b,a);
p=cplxpair(p1,10000000*eps);
I=cplxcomp(p1,p);
r=r1(I);
K=floor(N/2);
B=zeros(K,2);
A=zeros(K,3);
if K*2==N;
    for i=1:2:N-2
        Brow=r(i:1:i+1,:);
        Arow=p(i:1:i+1,:);
        [Brow,Arow]=residuez(Brow,Arow,[]);
        B(fix((i+1)/2),:)=real(Brow);
        A(fix((i+1)/2),:)=real(Arow);
    end
    [Brow,Arow]=residuez(r(N-1),p(N-1),[]);
    B(K,:)=[real(Brow) 0];
    A(K,:)=[real(Arow) 0];
else
    for i=1:2:N-1
       Brow=r(i:1:i+1,:);
        Arow=p(i:1:i+1,:);
        [Brow,Arow]=residuez(Brow,Arow,[]);
        B(fix((i+1)/2),:)=real(Brow);
        A(fix((i+1)/2),:)=real(Arow);
    end
end
在运行程序中，调用用户自定义编写的cplxcomp函数，把两个混乱的复数数组进行比较，返回一个
数组的下标，用它重新给一个数组排序。其代码如下：
function I=cplxcomp(p1,p2)
%I=cplxcomp(p1,p2)
%比较两个包含同样标量元素但(可能)有不同下标的复数对
%本程序必须用在cplxpair()程序后以便重新排序频率极点矢量
%及其相应的留数矢量
% p2=cplxpair(p1)
I=[];
for j=1:length(p2)
for i=1:length(p1)
if (abs((p1(i)-p2(j))<0.0001)
I=[I,i];
end
end
end
I=I’;
其实现的MATLAB程序代码如下：
clear all;
b=[1 -7 13 27 19];
a=[17 13 5 -6 -2];
N=25;
delta=impseq(0,0,N);
[C,B,A]=dir2par(b,a);     
h=parfilter(C,B,A,delta);  
x=[ones(1,5),zeros(1,N-5)];  %单位阶跃信号
y=casfilter(C,B,A,x);  
subplot(211);stem(h);
xlabel('(a) 直接型h(n)');
subplot(212);stem(y);
xlabel('(a) 直接型y(n)');
