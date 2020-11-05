Wp=3*pi*4*12^3;
Ws=2*pi*12*12^3;
rp=2;
rs=25;   %设计滤波器的参数
wp=1;ws=Ws/Wp;                               %对参数归一化
[N,wc]=ellipord(wp,ws,rp,rs, 's');            %计算滤波器阶数和阻带起始频率
[z,p,k]=ellipap(N,rp,rs);                    %计算零点、极点、增益
[B,A]=zp2tf(z,p,k);                          %计算系统函数的多项式
w=0:0.03*pi:2*pi;[h,w]=freqs(B,A,w);
plot(w,20*log10(abs(h)),'k');
xlabel('\lambda');ylabel('A(\lambda)/dB');grid;
