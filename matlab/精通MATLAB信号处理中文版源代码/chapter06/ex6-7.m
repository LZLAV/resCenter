clear all;
close all;clc;
b=[0.0202 0 -0.0403 0 0.0205];
a=[1 -1.647 2.247 -1.407 0.64];
[K,C]=tf2latc(b,a)
x=sin(0.1*pi*(0:79))+sin(0.35*pi*(0:79));
y1=filter(b,a,x);
y2=latcfilt(K,C,x);
subplot(311),
plot(0:79,x);xlabel('n');ylabel('x(n)');grid;
title('输入信号');axis([-1 81 -2.2 2.2]);
subplot(312),
plot(0:79,y1);xlabel('n');ylabel('y1(n)');grid;
title('直接型结构的输出');axis([-1 81 -1.2 1.2]);
subplot(313),
plot(0:79,y2);xlabel('n');ylabel('y2(n)');grid;
title('零极点系统的Lattice结构的输出');axis([-1 81 -1.2 1.2]);
set(gcf,'color','w');
