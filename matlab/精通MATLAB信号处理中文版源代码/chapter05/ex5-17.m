function hd=ideal_lp(wc,M);
%计算理想低通滤波器的脉冲响应
%[hd]=ideal_lp(wc,M)
%hd=理想脉冲响应0到M-1
%wc=截止频率
% M=理想滤波器的长度
alpha=(M-1)/2;
n=[0:1:(M-1)];
m=n-alpha+eps;
%加上一个很小的值eps避免除以0的错误情况出现
hd=sin(wc*m)./(pi*m);
运行程序如下：
clear all;
wp1=0.4*pi;
wp2=0.6*pi;
ws1=0.3*pi;
ws2=0.7*pi;
As=150;
tr_width=min((wp1-ws1),(ws2-wp2)); 					%过渡带宽度 
M=ceil(11*pi/tr_width)+1							%滤波器长度
n=[0:1:M-1];
wc1=(ws1+wp1)/2;									%理想带通滤波器的下截止频率
wc2=(ws2+wp2)/2;									%理想带通滤波器的上截止频率
hd=ideal_lp(wc2,M)-ideal_lp(wc1,M);
w_bla=(blackman(M))';								%布莱克曼窗
h=hd.*w_bla;
%截取得到实际的单位脉冲响应
[db,mag,pha,grd,w]=freqz_m(h,[1]);
%计算实际滤波器的幅度响应
delta_w=2*pi/1000;
Rp=-min(db(wp1/delta_w+1:1:wp2/delta_w))
%实际通带纹波
As=-round(max(db(ws2/delta_w+1:1:501)))
As=150
subplot(2,2,1);
stem(n,hd);
title('理想单位脉冲响应hd(n)')
axis([0 M-1 -0.4 0.5]);
xlabel('n');
ylabel('hd(n)')
grid on;
subplot(2,2,2);
stem(n,w_bla);
title('布莱克曼窗w(n)')
axis([0 M-1 0 1.1]);
xlabel('n');
ylabel('w(n)')
grid on;
subplot(2,2,3);
stem(n,h);
title('实际单位脉冲响应hd(n)')
axis([0 M-1 -0.4 0.5]);
xlabel('n');
ylabel('h(n)')
grid on;
subplot(2,2,4);
plot(w/pi,db);
axis([0 1 -150 10]);
title('幅度响应(dB)');
grid on;
xlabel('频率单位:pi');
ylabel('分贝数')
