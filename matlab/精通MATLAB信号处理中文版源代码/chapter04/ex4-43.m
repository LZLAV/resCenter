clear all;
wp=0.3*pi; 
ws=0.4*pi;   % 数字滤波器截止频率通带波纹
Rp=2; 
Rs=30;            %阻带衰减
Fs=100;  
Ts=1/Fs;    %采样频率
Nn=256;              %调用freqz所用的频率点数
wp=2/Ts*cos(wp/2);  
ws=2/Ts*cos(ws/2);  %按频率公式进行转换
[n,wn]=ellipord(wp,ws,Rp,Rs,'s');  %计算模拟滤波器的最小阶数
[z,p,k]=ellipap(n,Rp,Rs);          %设计模拟原型滤波器
[Bap,Aap]=zp2tf(z,p,k);            %零点极点增益形式转换为传递函数形式
[b,a]=lp2lp(Bap,Aap,wn);          %低通转换为低通滤波器的频率转换
[bz,az]=bilinear(b,a,Fs);         %运用双线性变换法得到数字滤波器传递函数
[h,f]=freqz(bz,az,Nn,Fs);         %绘出频率特性
subplot(121);plot(f,20*log10(abs(h)));
xlabel('频率/Hz');ylabel('振幅/dB');
grid on;
subplot(122);plot(f,180/pi*unwrap(angle(h)));
xlabel('频率/Hz');ylabel('相位/^o');
grid on;
