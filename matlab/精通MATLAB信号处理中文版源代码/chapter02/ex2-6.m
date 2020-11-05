clear all; close all; clc;
n=-21:21;
x=3*sin(0.2*pi*n+2*pi/3);
n1=-24:0.1:24;
x1=2*sin(0.2*pi*n1+2*pi/3);
stem(n,x,'.');hold on;plot(n1,x1,'--');
xlabel('n');ylabel('x(n)');title('3sin(0.2\pin+2\pi/3)的线图表示');
axis([-23.5 23.5 -2.1 2.1]);
set(gcf,'color','w');
