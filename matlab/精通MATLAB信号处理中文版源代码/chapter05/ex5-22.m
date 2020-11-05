close all;
clear all;clc;
N=33;
wc=pi/3;
N1=fix(wc/(2*pi/N)); 
A=[zeros(1,N1),0.5304,ones(1,N1),0.5304,zeros(1,N1*2-1),0.5304,ones(1,N1),0.5304,zeros(1,N1)];
theta=-pi*[0:N-1]*(N-1)/N;
H=A.*exp(j*theta);
h=real(ifft(H));v=1:N;
subplot(2,2,1),plot (v ,A,'k*');
title('频率样本');ylabel('H(k)');
axis([0,fix(N*1.1),-0.1,1.1]);
subplot(2,2,2),stem (v ,h,'k');
title('脉冲响应');ylabel('h(n)');
axis([0,fix(N*1.1),-0.3,0.4]);
M=500;nx=[1:N];
w=linspace(0,pi,M); X=h*exp(-j*nx'*w);
subplot(2,2,3),
plot(w./pi,abs(X),'k');
xlabel('\omega/\pi');ylabel('Hd(\omega)');
axis([0,1,-0.1,1.3]);title('幅度响应');
subplot(2,2,4),
plot(w./pi,20*log10(abs(X)),'k');
title('幅度响应');
xlabel('\omega/\pi');
ylabel('dB');
axis([0,1,-80,10]);
