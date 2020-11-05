clear all;
a = [1 0.5 2];      %滤波器传递函数分母多项式系数
b = [0.4 0.5 2];    %滤波器传递函数分子多项式系数
w = logspace(-1,1); 
freqs(b,a,w)
h = freqs(b,a,w);
mag = abs(h);
phase = angle(h);
subplot(2,1,1), loglog(w,mag)      %运用双对数坐标绘制幅频响应
grid on;
xlabel('角频率');ylabel('振幅');
subplot(2,1,2), semilogx(w,phase)   %运用半对数坐标绘相频响应
grid on;
xlabel('角频率');ylabel('相位');
