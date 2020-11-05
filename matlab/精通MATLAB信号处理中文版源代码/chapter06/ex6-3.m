clear all;
t=0:1/10000:1-0.0001;
s=cos(2*pi*t)+ sin(2*pi*t);         %输入信号
n=randn(size(t));      %产生随机噪声
x=s+n;
w=[0 0.5];
u=0.00026;
for i=1:9999
    y(i+1)=n(i:i+1)*w';
    e(i+1)=x(i+1)-y(i+1);
    w=w+2*u*e(i+1)*n(i:i+1);
end
figure;
subplot(3,1,1); plot(t,x);
title('带噪声输入信号');
subplot(3,1,2);plot(t,s);
title('输入信号');
subplot(3,1,3);plot(t,e);
title('滤波结果');
