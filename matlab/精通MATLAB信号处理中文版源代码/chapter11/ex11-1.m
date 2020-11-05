clear;clc;
close all;
fm=40;fc=400;T=1;
t=0:0.001:T;
m=2*cos(2*pi*fm*t);
dsb=m.*cos(2*pi*fc*t);
subplot(121);
plot(t,dsb);
title('DSB-AM调制信号');
xlabel('t');
%% DSB-AM 相干解调 %%
r=dsb.*cos(2*pi*fc*t);
r=r-mean(r);
b=fir1(40,0.01);
rt=filter(b,1,r);
subplot(122);
plot(t,rt);
title('相干解调后的信号');
xlabel('t');
