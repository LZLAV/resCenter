clear;clc;close all;
kf=10;
fc=2;
fm=0.5;
t=0:0.002:4;
m=cos(2*pi*fm*t);
ms=1/2/pi/fm*sin(2*pi*fm*t);
s=cos(2*pi*fc*t+2*pi*kf*ms);
subplot(121);plot(t,s);xlabel('t');title('调频信号');
for i=1:length(s)-1
    r(i)=(s(i+1)-s(i))/0.001;
end
r(length(s))=0;
subplot(122);
plot(t,r);
xlabel('t');
title('调频信号微分后的波形');
