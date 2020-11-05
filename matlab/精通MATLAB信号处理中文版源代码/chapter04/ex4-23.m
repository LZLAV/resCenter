clear all;
Rp=3;  Rs=25;       %模拟原型滤波器的通带波纹与阻带衰减
[z,p,k]=ellipap(4,Rp,Rs);  %设计椭圆滤波器
[b,a]=zp2tf(z,p,k);    %由零点极点增益形式转换为传递函数形式
n=0:0.02:4;
[h,w]=freqs(b,a,n);   %给出复数频率响应
subplot(121);plot(w,abs(h).^2);  %绘出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('原型低通椭圆滤波器 (wc=1)');
grid on;
[bt,at]=lp2lp(b,a,0.5);  %将模拟原型低通滤波器的截止频率变换为0.5
[ht,wt]=freqs(bt,at,n);   %给出复数频率响应
subplot(122);plot(wt,abs(ht).^2);  %绘出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('原型低通椭圆滤波器 (wc=0.6)');
grid on;
