clear all;
t=linspace(1e-3,100e-3,10);
xn=sin(100*2*pi*t);    %产生有限序列x(n)
N=length(xn);          %获得序列的长度
WNnk=dftmtx(N);  
Xk=xn*WNnk;       %计算x(n)的DFT
subplot(1,2,1);stem(1:N,xn);
subplot(1,2,2);stem(1:N,abs(Xk));
