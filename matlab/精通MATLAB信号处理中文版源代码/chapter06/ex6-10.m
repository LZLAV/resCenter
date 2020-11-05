%仿真信号功率谱估计和自相关函数
a=[2 0.3 0.2 0.5 0.2 0.4 0.6 0.2 0.2 0.5 0.3 0.2 0.6]; 
%仿真信号
t=0:0.001:0.4;
y=sin(2*pi*t*30)+cos(0.35*pi*t*30)+randn(size(t));
%加入白噪声正弦信号
x=filter(1,a,y);
%周期图估计，512点FFT
subplot(221);
periodogram(x,[],512,1000);
axis([0 500 -50 0]);
xlabel('频率/HZ');
ylabel('功率谱/dB');
title('周期图功率谱估计');
grid on;
%welch功率谱估计
subplot(222);
pwelch(x,128,64,[],1000);
axis([0 500 -50 0]);
xlabel('频率/HZ');
ylabel('功率谱/dB');
title('welch功率谱估计');
grid on;
subplot(212);
R=xcorr(x);
plot(R);
axis([0 600 -500 500]);
xlabel('时间/t');
ylabel('R(t)/dB');
title('x的自相关函数');
grid on;
