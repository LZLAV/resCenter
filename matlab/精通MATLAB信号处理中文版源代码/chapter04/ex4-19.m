Wp=[3*pi*9000,3*pi*16000];
Ws=[3*pi*7000,3*pi*17000];
rp=1;rs=30;                                 %模拟滤波器的设计指标
[N,wso]=cheb2ord(Wp,Ws,rp,rs,'s');           %计算滤波器的阶数
[b,a]=cheby2(N,rs,wso,'s');                  %计算滤波器的系统函数的分子、分母向量
w=0:3*pi*100:3*pi*25000;
[h,w]=freqs(b,a,w);                          %计算频率响应
plot(w/(2*pi),20*log10(abs(h)),'k');
xlabel('f(Hz)');ylabel('幅度(dB)');grid;
