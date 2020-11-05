Fs=40000;fp=5000;fs=9000;
rp=1;rs=30;
wp=2*fp/Fs;ws=2*fs/Fs;       %计算数字滤波器的设计指标
[N,wc]=buttord(wp,ws,rp,rs); %计算数字滤波器的阶数和通带截止频率
[b,a]=butter(N,wc);          %计算数字滤波器系统函数
w=0:0.01*pi:pi;
[h,w]=freqz(b,a,w);          %计算数字滤波器的幅频响应
plot(w/pi,20*log10(abs(h)), 'k');axis([0,1,-100,10]);
xlabel('\omega/\pi');ylabel('幅度(dB)');grid;
