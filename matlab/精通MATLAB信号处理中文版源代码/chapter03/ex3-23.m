clf; 
clear all ; 
close all;  
fs=100;
%采样率 
Ts=1/fs;    
t=0:Ts:10;   
gass=2^(1/4)*exp(-pi*(t).^2).*cos(5*pi*t);
% 生成一个高斯函数 
subplot(231);
plot(t,gass); 
title('高斯函数'); 
xlabel('t'); 
ylabel('幅度');
grid on;
T=0:Ts:10; 
ft=sin(T.^2+2*T)+sin(T.^2);
%生成要变换的信号函数 
subplot(232);
plot(t,ft); 
title('信号函数'); 
grid on;
xlabel('t');
ylabel('幅度');
y=fft(ft);
%信号做FFT变换 
amp=abs(y);
grid on;
subplot(233);
plot(amp); 
title('信号的FFT变换'); 
xlabel('f'); 
ylabel('幅度');
grid on;
subplot(234);
plot(t,imag(hilbert(ft)));
title('信号的HHT变换');
grid on;
shl=100;
%高斯窗每次平移点数 
shn=(length(t)-1)/shl;
%求高斯窗平移总次数 
y2=zeros(shn,2001); 
for k=0:shn-1; 
gassc=2^(1/4)*exp(-pi*(t-k*shl*Ts).^2).*cos(5*pi*t);
%平移后的高斯函数 
gassc2=gassc/sum(gassc.^2)
%归一化 
yl=conv(hilbert(ft),gassc2);
%短时傅立叶变换，即对信号与Gauss函数做卷积 
    y2(k+1,:)=yl; 
end 
[F,T]=size(y2); 
[F,T]=meshgrid(1:T,1:F); 
subplot(235);
mesh(F,T,abs(y2)) 
title('信号尺度分布图'); 
xlabel('t'); 
ylabel('f ') 
zlabel('幅度'); 
subplot(236);
contour(F,T,abs(y2))
%等高线图
title('信号时频图'); 

xlabel('F(Hz)'); 
ylabel('尺度')
