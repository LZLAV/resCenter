K = tf2latc(b/b(1));
clear all;close all;clc;
b=[3 12/11 6/5 3/4];
K=tf2latc(b/b(1))
x=[1 ones(1,31)];
h1=filter(b/b(1),1,x);
h2=latcfilt(K,x);
subplot(121),
stem(0:31,h1,'LineWidth',2);xlabel('n');ylabel('h1(n)');
title('直接型结构的冲激响应');axis([-1 33 -0.2 3]);
subplot(122),
stem(0:31,h2,'LineWidth',2);xlabel('n');ylabel('h2(n)');
title('Lattice结构的冲激响应');axis([-1 33 -0.2 3]);
set(gcf,'color','w');
