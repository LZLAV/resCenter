% fir 滤波器示例
clear;
close all;
clc;

%直接型
n = 0:10;
N = 30;
b = 0.9.^n;
delta = impseq(0,0,N);
h = filter(b,1,delta);
x = [ones(1,5),zeros(1,N-5)];
y = filter(b,1,x);
subplot(2,2,1);
stem(h);
title('直接型h(n)');
subplot(2,2,2);stem(y);
title('直接型y(n)');
[b0,B,A] = dir2cas(b,1);
h = casfilter(b0,B,A,delta);
y = casfilter(b0,B,A,x);
subplot(2,2,3);stem(h);
title('级联型');
subplot(2,2,4);stem(y);
title('级联型y(n)');