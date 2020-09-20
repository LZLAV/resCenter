clear all;
close all;
clc;
%{
n = 0:50;
A = 3;
a = -1/9;
b = pi/5;
x = A *exp((a+i*b)*n);
x = fliplr(x);  %序列翻转
subplot(2,2,1);
stem(n,real(x),'fill'); %实部
grid on;
title('实部');
axis([0 ,30,-2,2]);
xlabel('n');
subplot(2,2,2);
stem(n,imag(x),'fill'); %虚部
grid on;
title('虚部');
axis([0,30,-2,2]);
xlabel('n');
subplot(2,2,3);
stem(n,abs(x),'fill');  %模
grid on;
title('模');
axis([0,30,0,2]);
xlabel('n');
subplot(2,2,4);
stem(n,angle(x),'fill');    %相位
grid on;
title('相角');
axis([0,30,-2,2]);
xlabel('n');
%}

%{
% t->2t
t = -4:0.001:4;
T = 2;
f = tripuls(t,4,0.5);  % 矩形，tripuls()
%ft = rectpuls(2*t,T);
subplot(2,1,1);
plot(t,f);
axis([-4,4,-0.5,1.5]);
subplot(2,1,2);
%plot(t,ft);
axis([-4,4,-.5,1.5]);
%}


%{
t = 0:0.002:2;
y = chirp(t,0,1,150);
subplot(621);
plot(y);
subplot(622)
spectrogram(y,256,250,256,1E3,'yaxis');
xlabel('t=0:0.002:2 0->150');
title('不同采样时间的条件下');

t=-2:0.002:2;
y = chirp(t,100,1,200,'quadratic');
subplot(623);
plot(y);
subplot(624)
spectrogram(y,128,120,128,1E3,'yaxis');
xlabel('t = -2:0.002:2 100->200');


t=-1:0.002:1;
fo = 100;
f1 = 400;
y = chirp(t,fo,1,f1,'q',[],'convex');
subplot(625);
plot(y);
subplot(626)
spectrogram(y,256,200,256,1000,'yaxis');
xlabel('t = -1:0.002:1 100->400');

t=0:0.002:1;
fo = 100;
f1 = 25;
y = chirp(t,fo,1,f1,'q',[],'concave');
subplot(627);
plot(y);
subplot(6,2,8)
spectrogram(y,hanning(256),128,256,1000,'yaxis');
xlabel('t = 0:0.002:1 100->25');

t=0:0.002:10;
fo = 10;
f1 = 400;
y = chirp(t,fo,10,f1,'logarithmic');
subplot(6,2,9);
plot(y);
subplot(6,2,10)
spectrogram(y,256,200,256,1000,'yaxis');
xlabel('t = 0:0.002:10 10->400');
%}

%{
f = 6000;
nt=3;
N = 15;
T = 1/f;
n = 0:nt*N-1;
dt = T/N;
t = n*dt;
y = square(2*pi*f*t,25)+1;
plot(t,y,'k');
axis([0 nt*T 1.1*min(y) 1.1*max(y)]);
%}

%{
clf;
t = -3*pi:pi/40:4*pi;
plot(t,sinc(t));
%}


% 连续系统函数的微分方程求解
eq = 'D2y+3*Dy+2*y=0';
cond = 'y(0)=1,Dy(0)=2';
yzi = dsolve(eq,cond);
yzi = simplify(yzi)