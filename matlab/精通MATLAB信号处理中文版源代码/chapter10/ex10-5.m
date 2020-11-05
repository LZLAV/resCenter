[x,fs,bits]=wavread('qq.wav');
%sound(x)
%随机噪声合成
x2=rand(1,length(x))';   %产生一与x长度一致的随机信号   
y=x+x2;
%加入正弦噪声
%t=0:(size(x)-1);
%Au=0.3;
%d=[Au*sin(2*pi*500*t)]';
%y=x+d;
wp=0.1*pi;
ws=0.4*pi;
Rp=1;
Rs=15;
Fs=22050;
Ts=1/Fs;
wp1=2/Ts*tan(wp/2);                 %将模拟指标转换成数字指标
ws1=2/Ts*tan(ws/2); 
[N,Wn]=buttord(wp1,ws1,Rp,Rs,'s');  %选择滤波器的最小阶数
[Z,P,K]=buttap(N);                  %创建butterworth模拟滤波器
[Bap,Aap]=zp2tf(Z,P,K);
[b,a]=lp2lp(Bap,Aap,Wn);   
[bz,az]=bilinear(b,a,Fs);      %用双线性变换法实现模拟滤波器到数字滤波器的转换
[H,W]=freqz(bz,az);                 %绘制频率响应曲线
figure(1)
plot(W*Fs/(2*pi),abs(H))
grid
f1=filter(bz,az,y);
figure(2)
subplot(2,1,1)
plot(y)                          %画出滤波前的时域图
title('滤波前的时域波形');
subplot(2,1,2)
plot(f1);                         %画出滤波后的时域图
title('滤波后的时域波形');
sound(f1);                    %播放滤波后的信号
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
xlabel('频率');
ylabel('幅值');
