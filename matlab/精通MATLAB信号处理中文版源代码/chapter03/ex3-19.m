fs=256;%采样频率
N=512;%采样点数
nfft=512;
n=0:1:N-1;%时间序列号
%n/fs:采样频率下对应的时间序列值
n1=fs*(0:nfft/2-1)/nfft;%F F T对应的频率序列
x=3*sin(2*pi*100*n/fs)+3*cos(2*pi*101.45*n/fs)+2*sin(2*pi*102.3*n/fs)+4*cos(2*pi*103.8*n/fs)+5*sin(2*pi*104.5*n/fs);
figure;
subplot(231);
plot(n,x);
xlabel('时间t');
ylabel('value');
title('信号的时域波形');

XK=fft(x,nfft);%单边幅值谱
subplot(232);stem(n1,abs(XK(1:(nfft/2))));%用杆状来画FFT的图，也可以
axis([95,110,0,1500]);
title('直接利用FFT变换后的频谱');
subplot(233);plot(n1,abs(XK(1:(N/2))));
axis([95,110,0,1500]);
title('直接利用FFT变换后的频谱');

f1=100;%细化频率段起点
f2=110;%细化频率段终点
M=256;%细化频段的频点数，（这里其实就是细化精度）
w=exp(-j*2*pi*(f2-f1)/(fs*M));%细化频段的跨度（步长）
a=exp(j*2*pi*f1/fs);%细化频段的起始点，这里需要运算一下才能代入czt函数
xk=czt(x,M,w,a);
h=0:1:M-1;%细化频点序列
f0=(f2-f1)/M*h+100;%细化的频率值
subplot(234);stem(f0,abs(xk));
xlabel('f');
ylabel('value');
title('利用CZT变换后的细化频谱');
subplot(235);plot(f0,abs(xk));
xlabel('f');
ylabel('value');
title('利用CZT变换后的细化频谱');
