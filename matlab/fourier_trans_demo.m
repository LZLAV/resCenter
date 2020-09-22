clear;

%{
% 傅里叶变换
t = linspace(1e-3,100e-3,10);
xn = sin(100*2*pi*t);
N = length(xn);
WNnk = dftmtx(N);   
Xk = xn * WNnk;
y = fft(xn);    % 与上面三行效果等价
subplot(2,1,1);
stem(1:N,xn);
subplot(2,1,2);
stem(1:N,abs(Xk));
subplot(2,2,1)
stem(1:N,real(y));
%}

%{
% 离散傅里叶变换，未使用 fft
Dt = 0.00005;
t = -0.005:Dt:0.005;    % 模拟信号
xa = exp(-2000 * abs(t));
Ts = 0.0002;
n = -25:1:25;           % 离散时间信号
x = exp(-1000 *abs(n*Ts));
K =500;
k = 0:1:K;
w = pi*k/K;
% 离散时间傅里叶变换
X = x*exp(-j*n'*w);
X = real(X);
w = [-fliplr(w),w(2:501)];
X = [fliplr(X),X(2:501)];
figure;
subplot(2,2,1);
plot(t*100,xa,'.');
ylabel('x1(t)');
xlabel('t');
title('离散信号');
hold on;
stem(n * Ts *1000,x);
hold off;
subplot(2,2,2);
plot(w/pi,X,'.');
ylabel('X1(jw)');
xlabel('f');
title('离散时间傅里叶变换');
Ts = 0.001;
n = -25:1:25;
% 离散时间信号
x = exp(-1000 * abs(n*Ts));
K = 500;k=0:1:K;w = pi*k/K;
%离散时间傅里叶变换
X = x*exp(-j*n'*w);
X = real(X);
w = [-fliplr(w),w(2:501)];
X = [fliplr(X),X(2:501)];
subplot(2,2,3);
plot(t*1000,xa,'.');
ylabel('x2(t)');
xlabel('t');
title('离散信号');
hold on;
stem(n*Ts*1000,x);
hold off;
subplot(2,2,4);
plot(w/pi,X,'.');
ylabel('X2(jw)');
xlabel('f');
title('离散时间傅里叶变换');
%}


% 采用 sinc 内插重构
%{
Ts1 = 0.0002;
Fs1 = 1/Ts1;
n1 = -25:1:25;
nTs1 = n1 * Ts1;    % 离散时间信号
x1 = exp(-1000*abs(nTs1));
Ts2 = 0.001;
Fs2 = 1/Ts2;
n2 = -1:1:5;
nTs2 = n2*Ts2;
x2 = exp(-2000*abs(nTs2));
Dt  = 0.00005;
t = -0.005:Dt:0.005;
xa1 = x1 * sinc(Fs1*ones(length(nTs1),1) *t -nTs1'*ones(1,length(t)));
xa2 = x2 * sinc(Fs2*ones(length(nTs2),1) *t -nTs2'*ones(1,length(t)));
subplot(2,1,1);
plot(t*1000,xa1,'.');
ylabel('x1(t)');
xlabel('t');
title('从x1(n)重构模拟信号 x1(t)');
hold on;
stem(n1 * Ts1 *1000,x1);
hold off;
subplot(2,1,2);
plot(t*1000,xa2,'.');
ylabel('x2(t)');
xlabel('t');
title('从 x2(n)重构模拟信号x2(t)');
hold on;
stem(n2 *Ts2 * 1000,x2);
hold off;
%}

%{
fs = 100;
Ndata = 32;
N = 32;
n =0:Ndata-1;
t = n/fs;
x = 0.5*sin(2*pi*20*t) + 2*sin(2*pi*60*t);
y = fft(x,N);
mag = abs(y);
f = (0:N-1)*fs/N;
subplot(2,2,1);
plot(f(1:N/2),mag(1:N/2) * 2/N);
xlabel('频率/Hz');
ylabel('振幅');
title('Ndata = 32;FFT 所以采点个数=32');
grid on;

Ndata = 32;
N = 128;
n =0:Ndata-1;
t = n/fs;
x = 0.5*sin(2*pi*20*t) + 2*sin(2*pi*60*t);
y = fft(x,N);
mag = abs(y);
f = (0:N-1)*fs/N;
subplot(2,2,2);
plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');
ylabel('振幅');
title('Ndata =32;FFT 所以采点个数=128');
grid on;

Ndata = 136;
N = 128;
n = 0:Ndata-1;
t = n/fs;
x = 0.5*sin(2*pi*20*t)+2*sin(2*pi*60*t);
y = fft(x,N);
mag = abs(y);
f = (0:N-1)*fs/N;
subplot(2,2,3);
plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');
ylabel('振幅');
title('Ndata=136;FFT 所以采点个数=128');
grid on;

Ndata = 136;
N = 512;
n = 0:Ndata-1;
t = n/fs;
x = 0.5*sin(2*pi*20*t) +2*sin(2*pi*60*t);
y = fft(x,N);
mag = abs(y);
f = (0:N-1)*fs/N;
subplot(2,2,4);
plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');
ylabel('振幅');
title('Ndata =136;FFT 所以采点个数=512');
grid on;
%}


%{
N =1024;
f1 = .1;
f2 = .2;
fs =1;
a1 =5;a2=3;
w = 2*pi/fs;
x = a1*sin(w*f1*(0:N-1)) +a2 *cos(w*fs*(0:N-1)) +randn(1,N);
% 应用 FFT 求频谱
subplot(2,1,1);
plot(x(1:N/4));
title('原始信号');
f = -0.5:1/N:0.5-1/N;
X = fft(x);
subplot(2,1,2);
plot(f,fftshift(abs(X)));   % fftshift 将零频率的分量移到频谱中心
title('频域信号');
%}


% 傅里叶逆变换

fs = 200;       %采样频率
N = 128;        %数据个数
n = 0:N-1;
t = n/fs;
x = 0.5*sin(2*pi*20*t) +2*sin(2*pi*60*t);   %数据对应的时间序列
subplot(2,2,1);         
plot(t,x);      %时间域信号
xlabel('时间/s');
ylabel('x');
title('原始信号');
grid on;

y = fft(x,N);       %傅里叶变换
mag = abs(y);       %得到振幅谱
f = n*fs/N;         %频率序列
subplot(2,2,2);
plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');
ylabel('振幅');
title('原始信号的FFT');
grid on;

xifft = ifft(y);        %进行傅里叶逆变换
realx = real(xifft);    %求取傅里叶逆变换的实部
ti = [0:length(xifft)-1]/fs;    %傅里叶逆变换的时间序列
subplot(2,2,3);
plot(ti,realx);
xlabel('时间/s');
ylabel('x');
title('运用傅里叶逆变换得到的信号');
grid on;

yif = fft(xifft,N);     %将傅里叶逆变换得到的时间域信号进行傅里叶变换
mag = abs(yif);
f = [0:length(y)-1]'* fs/length(y);     %频率序列
subplot(2,2,4);
plot(f(1:N/2),mag(1:N/2)*2/N);
xlabel('频率/Hz');
ylabel('振幅');
title('运用 IFFT得到信号的快速傅里叶变换');
grid on;


