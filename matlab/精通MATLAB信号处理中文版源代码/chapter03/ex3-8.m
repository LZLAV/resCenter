clc;
N=32;
x_delta=zeros(1,N);
x_delta(1)=1;
p=[1,-1,0]
d=[1,0.75,0.125];
h1_delta=filter(p,d,x_delta);
subplot(211);
stem(0:N-1,h1_delta,'r');hold off;
xlabel('方程1的单位脉冲响应');
x_unit=ones(1,N);
h1_unit=filter(p,d,x_unit);
subplot(212);
stem(0:N-1,h1_unit,'r');hold off;
xlabel('方程1的阶跃响应');
