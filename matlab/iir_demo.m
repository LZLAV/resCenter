clear all;
clf;
clc;
close all;

% filter 基本使用
%{
data = [1:0.2:4]';
windowSize = 5;
filter(ones(1,windowSize)/windowSize,1,data) %b =(1/5 1/5 1/5 1/5 1/5),a=1
%}

% 求输入信号的差分响应
%{
b = [1,-3,13,27,18];
a = [15,11,2,-4,-2];
N =30;
delta = impz(b,a,N);    % 求解系统的冲激响应
x = [ones(1,5),zeros(1,N-5)];
h = filter(b,a,delta);
y = filter(b,a,x);
subplot(211);stem(h);title('直接型 h(n)');
subplot(212);stem(y);title('直接型y(n)')
%}


% 级联型系统结构的实现
%{
b0 =1;
N =30;
B = [1,1,0;1,-3.1415926,1];
A = [1,-0.6,0;1,0.7,0.72];
% delta = impseq(0,0,N);
x = [ones(1,5),zeros(1,N-5)];
% h = casfilter(b0,B,A,dalta);    % 级联型单位冲激响应
y = casfilter(b0,B,A,x);        % 级联型输出响应
subplot(211);
%stem(h);
title('级联型h(n)');
subplot(212);
stem(y);
title('级联型y(n)');
%}

% 直接型和级联型输出比较
%{
n = 0:5;
b = 0.2.^n;
N = 30;
B = [1,-7,13,27,19];
A = [17,13,5,-6,-2];
% delta = impseq(0,0,N);
%h = filter(b,1,delta);  % 直接型
x = [ones(1,5),zeros(1,N-5)];
y =filter(b,1,x);
%subplot(221);stem(h);title('直接型h(n)');
subplot(222);stem(y);title('直接型y(n)');
[b0,B,A] = dir2cas(b,1);
%h =casfilter(b0,B,A,delta);
y = casfilter(b0,B,A,x);
%subplot(223);stem(h);title('级联型h(n)');
subplot(224);stem(y);title('级联型y(n)');
%}

% 级联型转直接型
%{
b0 =3;
N =30;
B =[1,1,0;1,-3.1415926,1];
A = [1,-0.6,0;1,0.7,0.72];
%delta = impseq(0,0,N);
x = [ones(1,5),zeros(1,N-5)];
[b,a] = cas2dir(b0,B,A);
%h = filter(b,a,delta);      % 直接型单位冲激响应
y = filter(b,a,x);          % 直接型输出响应
%subplot(211);stem(h);
%title('级联型h(n)');
subplot(212);stem(y);
title('级联型y(n)');
%}


% 并联型结构实现IIR数字滤波器
%{
C = 0;
N = 30;
B = [-13.65,-14.81;32.60,16.37];
A = [1,-2.95,3.14;1,-1,0.5];
%delta =  impseq(0,0,N);
x = [ones(1,5),zeros(1,N-5)];
%h = parfiltr(C,B,A,delta);      % 并联型单位冲激响应,delta 指的是增量、差值
y = parfiltr(C,B,A,x);
%subplot(211);stem(h);
title('并联型h(n)');
subplot(212);stem(y);
title('并联型y(n)');
%}

%直接型转换为并联型结构
%{
b = [1 -7 13 27 19];
a = [17 13 5 -6 -2];
N = 25;
%delta = impseq(0,0,N);
[C,B,A] = dir2par(b,a);
%h = parfilter(C,B,A,delta);
x = [ones(1,5),zeros(1,N-5)];
y = casfilter(C,B,A,x);
subplot(211);
%stem(h);
xlabel('(a)直接型h(n)');
subplot(212);
stem(y);
xlabel('(a)直接型y(n)');
%}

% 并联型转换直接型
C =0;
B = [-13.65 -14.81;32.60 16.37];
A = [1,-2.95,3.14;1,-1,0.5];
N = 60;
%delta = impseq(0,0,N);
[b,a] = par2dir(C,B,A);
%h = filter(b,a,delta);
x = [ones(1,5),zeros(1,N-5)];
y = filter(b,a,x);
%subplot(211);stem(h);
xlabel('(a)直接型h(n)');
subplot(212);stem(y);
xlabel('(a)直接型y(n)');

