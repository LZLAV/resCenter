clear all;
Rp=0.5;      %设置滤波器的通带波纹为0.5dB
[z,p,k]=cheb1ap(5,Rp);  %设计契比雪夫I型模拟原型滤波器
[b,a]=zp2tf(z,p,k);    %由零点极点增益形式转换为传递函数形式
n=0:0.02:4;
[h,w]=freqs(b,a,n);   %给出复数频率响应
subplot(121);plot(w,abs(h).^2);  %绘出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('契比雪夫I型低通原型滤波器 (wc=1)');
grid on;
[bt,at]=lp2hp(b,a,0.6);  %由低通原型滤波器转换为截止频率为0.8的高通滤波器
[ht,wt]=freqs(bt,at,n);   %给出复数频率响应
subplot(122);plot(wt,abs(ht).^2);  %绘出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('契比雪夫I型高通滤波器 (wc=0.6)');
grid on;
