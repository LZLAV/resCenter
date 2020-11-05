clear all;
Nwin=20;     % 数据总数
n=0:Nwin-1;  % 数据序列序号
w=bartlett(Nwin); 
subplot(131);stem(n,w);  %绘出窗函数
xlabel('n');ylabel('w(n)');
grid on;
Nf=512;  %窗函数复数频率特性的数据点数
Nwin=20;     % 窗函数数据长度
[y,f]=freqz(w,1,Nf);
mag=abs(y);  %求得窗函数幅频特性
w=bartlett(Nwin); 
subplot(132);plot(f/pi,20*log10(mag/max(mag)));  %绘制窗函数的幅频特性
xlabel('归一化频率');ylabel('振幅/dB');
grid on;
w=blackman(Nwin);
[y,f]=freqz(w,1,Nf);
mag=abs(y);  %求得窗函数幅频特性
subplot(133);plot(f/pi,20*log10(mag/max(mag)));  %绘制窗函数的幅频特性
xlabel('归一化频率');ylabel('振幅/dB');
grid on;
