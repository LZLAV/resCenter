clear all;
[z,p,k]=buttap(5);  %设计巴特沃思模拟原型滤波器
[b,a]=zp2tf(z,p,k);    %由零点极点增益形式转换为传递函数形式
n=0:0.02:4;
[h,w]=freqs(b,a,n);   %给出复数频率响应
subplot(121);
plot(w,abs(h).^2);  %绘出平方幅频函数
xlabel('w/wc');ylabel('巴特沃思|H(jw)|^2');
title(' wc=1');
grid on;
w1=0.6; 
w2=1.6;  %给定将要设计带阻的下限和上限频率
w0=sqrt(w1*w2);  %计算中心点频率
bw=w2-w1;        %计算中心点频带宽度
[bt,at]=lp2bs(b,a,w0,bw);  %频率转换
[ht,wt]=freqs(bt,at,n);   %计算带阻滤波器的复数频率响应
subplot(122);
plot(wt,abs(ht).^2);  %绘出平方幅频函数
xlabel('w/wc');
ylabel('巴特沃思|H(jw)|^2');
title(' wc=0.6~1.6');
grid on;
