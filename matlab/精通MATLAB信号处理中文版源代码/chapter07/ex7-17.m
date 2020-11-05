clear; 
clc; 
N=1024; 
Nfft=128; 
n=[0:N-1]; 
randn('state',0); 
wn=randn(1,N); 
xn=sqrt(20)*sin(2*pi*0.6*n)+sqrt(20)*sin(2*pi*0.5*n)+wn; 
[Pxx1,f]=pburg(xn,15,Nfft,1);
%用Brug法进行功率谱估计，阶数为15，点数为1024 
Pxx1=10*log10(Pxx1); 
hold on; 
subplot(2,2,1);plot(f,Pxx1); 
xlabel('频率'); 
ylabel('功率谱(dB)'); 
title('Burg法  阶数=15,N=1024'); 
grid on; 
[Pxx2,f]=pburg(xn,20,Nfft,1);
%用Brug法进行功率谱估计，阶数为20，点数为1024 
Pxx2=10*log10(Pxx2); 
hold on 
subplot(2,2,2);plot(f,Pxx2); 
xlabel('频率'); 
ylabel('功率谱(dB)'); 
title('Burg法  阶数=20,N=1024'); 
grid on; 
N=512; 
Nfft=128; 
n=[0:N-1]; 
randn('state',0); 
wn=randn(1,N); 
xn=sqrt(20)*sin(2*pi*0.2*n)+sqrt(20)*sin(2*pi*0.3*n)+wn; 
[Pxx3,f]=pburg(xn,15,Nfft,1);
%用Brug法进行功率谱估计，阶数为15，点数为512 
Pxx3=10*log10(Pxx3); 
hold on 
subplot(2,2,3);plot(f,Pxx3); 
xlabel('频率'); 
ylabel('功率谱 (dB)'); 
title('Burg法  阶数=15,N=512'); 
grid on; 
[Pxx4,f]=pburg(xn,10,Nfft,1);
%用Brug法进行功率谱估计，阶数为10，点数为256 
Pxx4=10*log10(Pxx4); 
hold on 
subplot(2,2,4);plot(f,Pxx4); 
xlabel('频率'); 
ylabel('功率谱(dB)'); 
title('Burg法  阶数=10,N=256'); 
grid on;
