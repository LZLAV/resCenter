clear all;
ee=0;
fs=800;         %采样频率800Hz
det=1/fs;
f1=100;  f2=200;
t=0:det:2-det;
x=sin(2*pi*f1*t)+cos(2*pi*f2*t)+ randn(size(t));;
% 未知系统
[b,a]=butter(5,150*2/fs);       %截止频率取150Hz
d=filter(b,a,x);        %自适应FIR滤波器
N=5;
delta=0.06;
M=length(x);
y=zeros(1,M);
h=zeros(1,N);
for n=N:M
    x1=x(n:-1:n-N+1);
    y(n)=h*x1';
    e(n)=d(n)-y(n);
    h=h+delta.*e(n).*x1;
end
x=abs(fft(x,2048));
Nx=length(x);
kx=0:800/Nx:(Nx/2-1)*(800/Nx);
D=abs(fft(d,2048));
Nd=length(D);
kd=0:800/Nd:(Nd/2-1)*(800/Nd);
y=abs(fft(y,2048));
Ny=length(y);
ky=0:800/Ny:(Ny/2-1)*(800/Ny);
figure;
subplot(131);plot(kx,x(1:Nx/2));
xlabel('Hz');title('原始信号频谱');
subplot(132);plot(kd,D(1:Nd/2));
title('经未知系统后');xlabel('Hz');
subplot(133);plot(ky,y(1:Ny/2));
title('经自适应FIR滤波器后');xlabel('Hz');
