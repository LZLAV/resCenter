clear;
close all;
clc;
M=9;
L=512;
P=4;
ini_phase=0;
roll_off=0.7;
bit = randint(1,L,M);
x=exp(j*(2*pi*bit/M)+ini_phase);
N=L*P; y=zeros(1,N);
for n=1:N
    y(n)=0;
    for k=1:L
        t=(n-1)/P-(k-1);
        y(n)=y(n) + x(k) *
 ( sin(pi*t+eps)/(pi*t+eps) ) * ( cos(roll_off*pi*t+eps)/((1-(2*roll_off*t)^2)+eps) ) ;
    end
end
sfft=abs(fft(y));
sfft=sfft.^2/length(sfft);
subplot(311);
plot(real(x),imag(x),'.');
axis equal;
title('PSK信号星座图');
subplot(312);
plot(1:length(sfft),sfft);
title('PSK基带信号功率谱图');
for n=1:N
    z(n)=y(n)*exp(j*2*pi*1*n/P);
end
sfft=abs(fft(z));
sfft=sfft.^2/length(sfft);
subplot(313);
plot(1:length(sfft),sfft);
title('PSK调制信号功率谱图');
