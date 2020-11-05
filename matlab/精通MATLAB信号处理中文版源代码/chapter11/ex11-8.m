clear;close all;clc;
M=9;
L=1024;
P=8;
ini_phase=0;
roll_off=0.35;
a=2*randint( 1,L,sqrt(M) )-( sqrt(M)-1 );
b=2*randint( 1,L,sqrt(M) )-( sqrt(M)-1 );
x=a+j*b;N=L*P;
y=zeros(1,N);
for n=1:N
    y(n)=0;
    for k=1:L
        t=(n-1)/P-(k-1);
        y(n)=y(n) + x(k) * ( sin(pi*t+eps)/(pi*t+eps) ) * ...
( cos(roll_off*pi*t+eps)/((1-(2*roll_off*t)^2)+eps) ) ;
    end
end
sfft=abs(fft(y));
sfft=sfft.^2/length(sfft);
subplot(311);
plot(real(x),imag(x),'.');
axis equal;
title('9QAM信号星座图');
subplot(312);
plot(1:length(sfft),sfft);
title('9QAM基带信号功率谱图');
for n=1:N
    z(n)=y(n)*exp(j*2*pi*1*n/P);
end
sfft=abs(fft(z));
sfft=sfft.^2/length(sfft);
subplot(313);
plot(1:length(sfft),sfft);
title('9QAM调制信号功率谱图');
