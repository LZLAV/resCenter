fs=22050;
[x,fs,bits]=wavread('qq.wav');
%sound(x)
t=0:(size(x)-1);
x2=rand(1,length(x))';   %产生一与x长度一致的随机信号   
y=x+x2;
%加入正弦噪声
t=0:(n-1);	
Au=0.03;
d=[Au*sin(2*pi*500*t)]';
y=x+d;
wp=0.25*pi;
ws=0.3*pi;
wdelta=ws-wp;
N=ceil(6.6*pi/wdelta);              %取整
wn=(0.2+0.3)*pi/2;
b=fir1(N,wn/pi,hamming(N+1));       %选择窗函数，并归一化截止频率
figure(1)
freqz(b,1,512)
f2=filter(bz,az,y)
figure(2)
subplot(2,1,1)
plot(t,y)
title('滤波前的时域波形');
subplot(2,1,2)
plot(t,f2);
title('滤波后的时域波形');
sound(f2);                    %播放滤波后的语音信号
F0=fft(f1,1024);
f=fs*(0:511)/1024;
figure(3)
y2=fft(y,1024);
subplot(2,1,1);
plot(f,abs(y2(1:512)));             %画出滤波前的频谱图
title('滤波前的频谱')
xlabel('频率');
ylabel('幅值');
subplot(2,1,2)
F1=plot(f,abs(F0(1:512)));          %画出滤波后的频谱图
title('滤波后的频谱')
xlabel('Hz');
ylabel('幅值');
