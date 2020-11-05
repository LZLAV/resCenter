function hd=ideal_bs(Wcl,Wch,m); 
alpha=(m-1)/2; 
n=[0:1:(m-1)];
m=n-alpha+eps; 
hd=[sin(m*pi)+sin(Wcl*m)-sin(Wch*m)]./(pi*m)
调用子程序2：
function[db,mag,pha,w]=freqz_m2(b,a)
[H,w]=freqz(b,a,1000,'whole');
H=(H(1:1:501))'; w=(w(1:1:501))';
mag=abs(H);
db=20*log10((mag+eps)/max(mag));
pha=angle(H);
运行MATLAB源代码如下：
clear all;
Wph=3*pi*6.25/15;
Wpl=3*pi/15;
Wsl=3*pi*2.5/15;
Wsh=3*pi*4.75/15;
tr_width=min((Wsl-Wpl),(Wph-Wsh));
%过渡带宽度
N=ceil(4*pi/tr_width);					%滤波器长度
n=0:1:N-1;
Wcl=(Wsl+Wpl)/2;						%理想滤波器的截止频率
Wch=(Wsh+Wph)/2;
hd=ideal_bs(Wcl,Wch,N);				%理想滤波器的单位冲击响应
w_ham=(boxcar(N))';
string=['矩形窗','N=',num2str(N)];
h=hd.*w_ham;						%截取取得实际的单位脉冲响应
[db,mag,pha,w]=freqz_m2(h,[1]);
%计算实际滤波器的幅度响应
delta_w=2*pi/1000;
subplot(241);
stem(n,hd);
title('理想脉冲响应hd(n)')
axis([-1,N,-0.5,0.8]);
xlabel('n');ylabel('hd(n)');
grid on
subplot(242);
stem(n,w_ham);
axis([-1,N,0,1.1]);
xlabel('n');ylabel('w(n)');
text(1.5,1.3,string);
grid on
subplot(243);
stem(n,h);title('实际脉冲响应h(n)');
axis([0,N,-1.4,1.4]);
xlabel('n');ylabel('h(n)');
grid on
subplot(244);
plot(w,pha);title('相频特性');
axis([0,3.15,-4,4]);
xlabel('频率（rad）');ylabel('相位（Φ）');
grid on
subplot(245);
plot(w/pi,db);title('幅度特性（dB）');
axis([0,1,-80,10]);
xlabel('频率（pi）');ylabel('分贝数');
grid on
subplot(246);
plot(w,mag);title('频率特性')
axis([0,3,0,2]);
xlabel('频率（rad）');ylabel('幅值');
grid on
fs=15000;
t=(0:100)/fs;
x=cos(2*pi*t*750)+cos(2*pi*t*3000)+cos(2*pi*t*6100);
q=filter(h,1,x);
[a,f1]=freqz(x);
f1=f1/pi*fs/2;
[b,f2]=freqz(q);
f2=f2/pi*fs/2;
subplot(247);
plot(f1,abs(a));
title('输入波形频谱图');
xlabel('频率');ylabel('幅度')
grid on
subplot(248);
plot(f2,abs(b));
title('输出波形频谱图');
xlabel('频率');ylabel('幅度')
grid on
