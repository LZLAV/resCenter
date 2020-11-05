clear all;
wp=2000*2*pi;  
ws=3000*2*pi;   %滤波器截止频率
Rp=3;      
Rs=15;   %通带波纹和阻带衰减
Fs=9000;           %采样频率
Nn=256;              %调用freqz所用的频率点数
[N,wn]=buttord(wp,ws,Rp,Rs,'s');       %模拟滤波器的最小阶数
[z,p,k]=buttap(N);    %设计模拟低通原型Butterworth滤波器
[Bap,Aap]=zp2tf(z,p,k);   %将零点极点增益形式转换为传递函数形式
[b,a]=lp2lp(Bap,Aap,wn);  %进行频率转换
[bz,az]=impinvar(b,a,Fs);
% 运用脉冲响应不变法得到数字滤波器的传递函数
figure;
[h,f]=freqz(bz,az,Nn,Fs);        %绘制数字滤波器的幅频特性和相频特性
subplot(221);
 plot(f,20*log10(abs(h)));
xlabel('频率/Hz');  
ylabel('振幅/dB');
grid on;
subplot(222);
plot(f,180/pi*unwrap(angle(h)));
xlabel('频率/Hz');  
ylabel('相位/^o');
grid on;
f1=1000;  f2=2000;   %输入信号的频率
N=100;    %数据长度
dt=1/Fs;  n=0:N-1;  %采样时间间隔
t=n*dt;   %时间序列
x=tan(2*pi*f1*t)+0.5*sin(2*pi*f2*t);  %滤波器输入信号
subplot(223);plot(t,x);
title('输入信号');   %绘制输入信号
y=filtfilt(bz,az,x);  %用函数filtfilt对输入信号进行滤波
y1=filter(bz,az,x);   %用filter函数对输入信号进行滤波
subplot(224);plot(t,y,t,y1,':');
title('输出信号'); xlabel('时间/s');
legend('filtfilt函数','filter函数');  
