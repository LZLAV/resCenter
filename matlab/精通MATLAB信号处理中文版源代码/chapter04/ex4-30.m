T=2;							%设置采样周期为2
fs=1/T;						%采样频率为周期倒数
Wp=0.30*pi/T; 
Ws=0.35*pi/T;					%设置归一化通带和阻带截止频率
Ap=20*log10(1/0.8);
As=20*log10(1/0.18);			%设置通带最大和最小衰减   
[N,Wc]=buttord(Wp,Ws,Ap,As,'s');
%调用butter函数确定巴特沃斯滤波器阶数
[B,A]=butter(N,Wc,'s');
%调用butter函数设计巴特沃斯滤波器
W=linspace(0,pi,400*pi);		%指定一段频率值 
hf=freqs(B,A,W);
%计算模拟滤波器的幅频响应 
subplot(121);
plot(W/pi,abs(hf)/abs(hf(1)));
%绘出巴特沃斯模拟滤波器的幅频特性曲线 
grid on;
title('巴特沃斯模拟滤波器');
xlabel('Frequency/Hz');
ylabel('Magnitude');
[D,C]=impinvar(B,A,fs);
%调用脉冲响应不变法
Hz=freqz(D,C,W);
%返回频率响应 
subplot(122);
plot(W/pi,abs(Hz)/abs(Hz(1)));
%绘出巴特沃斯数字低通滤波器的幅频特性曲线 
grid on;
title('巴特沃斯数字滤波器');
xlabel('Frequency/Hz');
ylabel('Magnitude');
