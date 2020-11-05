Wp=3*pi*4*12^3;
Ws=3*pi*12*10^3;
rp=1;
rs=30;   %设计滤波器的参数
wp=1;ws=Ws/Wp;                               %对参数归一化
[N,wc]=cheb2ord(wp,ws,rp,rs, 's');            %计算滤波器阶数和阻带起始频率
[z,p,k]=cheb2ap(N,rs);                       %计算零点、极点、增益
[B,A]=zp2tf(z,p,k);                          %计算系统函数的多项式
w=0:0.02*pi:pi;
[h,w]=freqs(B,A,w);
plot(w*wc/wp,20*log10(abs(h)),'k');grid;
xlabel('\lambda');ylabel('A(\lambda)/dB');
