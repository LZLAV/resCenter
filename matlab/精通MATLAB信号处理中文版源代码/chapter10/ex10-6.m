Ft=8000;
Fp=1000;
Fs=1200;
wp=2*pi*Fp/Ft;
ws=2*pi*Fs/Ft;
fp=2*Ft*tan(wp/2);
fs=2*Fs*tan(wp/2);
[n11,wn11]=buttord(wp,ws,1,50,'s'); %求低通滤波器的阶数和截止频率
[b11,a11]=butter(n11,wn11,'s');    %求S域的频率响应的参数 
[num11,den11]=bilinear(b11,a11,0.5); %利用双线性变换实现频率响应S域到Z域的变换 
[x,fs,nbits]=wavread ('qq.wav');
n = length (x) ;         %求出语音信号的长度
t=0:(n-1);
x2=rand(1,length(x))';   %产生一与x长度一致的随机信号   
y=x+x2;
%加入正弦噪声
%t=0:(size(x)-1);
%Au=0.03;
%d=[Au*sin(2*pi*500*t)]';
%y=x+d;
figure(1)
f2=filter(num11,den11,y)
subplot(2,1,1)
plot(t,y)
title('滤波前的加高斯噪声时域波形');
subplot(2,1,2)
plot(t,f2);                         %画出滤波后的时域图
title('滤波后的时域波形');
sound(f1);                    %播放滤波后的信号
F0=fft(f1,1024);
f=fs*(0:511)/1024;
figure(2)
y2=fft(y,1024);
subplot(2,1,1);
plot(f,abs(y2(1:512)));             %画出滤波前的频谱图
title('滤波前加高斯噪声的频谱')
xlabel('频率');
ylabel('幅值');
subplot(2,1,2)
F1=plot(f,abs(F0(1:512)));          %画出滤波后的频谱图
title('滤波后的频谱')
xlabel('Hz');
ylabel('幅值');
