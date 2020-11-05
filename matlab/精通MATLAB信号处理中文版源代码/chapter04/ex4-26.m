Wc1=3*pi*9000;
Wc2=3*pi*16000;
rp=2;
rs=25;
Wd1=3*pi*6000;
Wd2=3*pi*20000;           %模拟滤波器的设计指标
B=Wc2-Wc1;
wo=sqrt(Wc1*Wc2);wp=1;
ws2=(Wd2*Wd2-wo*wo)/Wd2/B;
ws1=-(Wd1*Wd1-wo*wo)/Wd1/B;
ws=min(ws1,ws2);                        %频带变换，得到归一化滤波器
[N,wc]=cheb1ord(wp,ws,rp,rs, 's');       %计算切比雪夫I型滤波器的阶数
[z,p,k]=cheb1ap(N,wc);                  %计算归一化滤波器的零、极点
[bp,ap]=zp2tf(z,p,k);                   %计算归一化滤波器的系统函数分子、分母系数
[b,a]=lp2bp(bp,ap,wo,B);                %计算一般模拟滤波器的系统函数分子、分母系数
w=0:3*pi*130:3*pi*25000;               
[h,w]=freqs(b,a,w);                     %计算频率响应
plot(w/(2*pi),20*log10(abs(h)), 'k'),axis([0,30000,-100,0]);
xlabel('f(Hz)');
ylabel('幅度(dB)');
grid;
