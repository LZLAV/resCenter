wc=2*1000*tan(2*pi*400/(2*1000));
wt=2*1000*tan(2*pi*317/(2*1000));
[N,wn]=cheb1ord(wc,wt,0.5,19,'s');
%选择最小阶和截止频率
%设计高通滤波器
[B,A]=cheby1(N,0.5,wn, 'high','s'); 
%设计切比雪夫I型模拟滤波器
[num,den]=bilinear(B,A,1000);
%数字滤波器设计
[h,w]=freqz(num,den);
f=w/pi*500;
plot(f,20*log10(abs(h)));
axis([0,500,-80,10]);
grid;
xlabel('频率/Hz')
ylabel('幅度/dB')
