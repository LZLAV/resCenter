function y=casfilter(b0,B,A,x)
[K,L]=size(B);
N=length(x);
w=zeros(K+1,N);
w(1,:)=x;
for i=1:1:K
w(i+1,:)=filter(B(i,:),A(i,:),w(i,:));
end
y=b0*w(K+1,:);
%IIR滤波器的级联型实现
% y=casfilter(b0,B,A,x)
%y为输出
%b0=增益系数
%B=包含各因子系数bk的K行3列矩阵
%A=包含各因子系数ak的K行3列矩阵
%x为输入

nction [x,n]=impseq(n0,n1,n2)
% Generate x(n)=delta(n-n0);n1<=n<=n2
n=[n1:n2];
[x,n]=impseq(n0,n1,n2)

clear all
b0=3;
N=30;
B=[1,1,0;1,-3.1415926,1];
A=[1,-0.6,0;1,0.7,0.72];
delta=impseq(0,0,N);
x=[ones(1,5),zeros(1,N-5)];
h=casfilter(b0,B,A,delta);				%级联型单位脉冲响应
y=casfilter(b0,B,A,x)					%级联型输出响应
subplot(211);
stem(h);title('级联型h(n)');
subplot(212);
stem(y);title('级联型y(n)');

