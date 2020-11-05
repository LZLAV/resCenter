clear all;
Rs=30;      %滤波器的阻带衰减为20dB
[z,p,k]=cheb2ap(4,Rs);  %设计契比雪夫II型模拟原型滤波器
 [b,a]=zp2tf(z,p,k);    %由零点极点增益形式转换为传递函数形式
n=0:0.02:4;
[h,w]=freqs(b,a,n);   %给出复数频率响应
subplot(121);plot(w,abs(h).^2);  %绘出平方幅频函数
xlabel('w/wc');ylabel('契比雪夫II型|H(jw)|^2');
title('契比雪夫II型低通原型滤波器 (wc=1)');
grid on;
w1=0.7; w2=1.6;  %给定将要设计滤波器通带的下限和上限频率
w0=sqrt(w1*w2);  %计算中心点频率
bw=w2-w1;        %计算中心点频带宽度
[bt,at]=lp2bp(b,a,w0,bw);  %频率转换
[ht,wt]=freqs(bt,at,n);   %计算滤波器的复数频率响应
subplot(122);plot(wt,abs(ht).^2);  %绘出平方幅频函数
xlabel('w/wc');ylabel('契比雪夫II型|H(jw)|^2');
title('契比雪夫II型带通滤波器 (wc=0.7~1.6)');
grid on;
