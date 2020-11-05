Wp=3*pi*11000;
Ws=3*pi*7000;
rp=2;
rs=25;  %模拟滤波器的设计指标
wp=Wp/Wp;ws=Wp/Ws;                      %频带变换，得到归一化滤波器
[N,wc]=cheb1ord(wp,ws,rp,rs, 's');       %计算切比雪夫I型滤波器的阶数
[z,p,k]=cheb1ap(N,wc);                  %计算归一化滤波器的零、极点
[bp,ap]=zp2tf(z,p,k);                   %计算归一化滤波器的系统函数分子、分母系数
[b,a]=lp2hp(bp,ap,Wp);                  %计算一般模拟滤波器的系统函数分子、分母系数
w=0:3*pi*130:3*pi*25000;               
[h,w]=freqs(b,a,w);                     %计算频率响应
plot(w/(2*pi),20*log10(abs(h)), 'k');grid;xlabel('f(Hz)');ylabel('幅度(dB)');
