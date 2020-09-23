clf;
clear;
close all;

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

%{
t = linspace(1e-3,100e-3,10);
xn = sin(100*2*pi*t);
N = length(xn);
WNnk = dftmtx(N);
Xk = xn * WNnk;
y = fft(xn);
subplot(2,1,1);
stem(1:N,xn);
subplot(2,1,2);
stem(1:N,abs(Xk));
subplot(2,2,1)
stem(1:N,real(y));
%}

%{
% 利用 FFT 进行滤波示例
dt = 0.05;
N = 1024;
n = 0:N-1;
t = n*dt;       % 时间序列
f = n/(N*dt);   % 频率序列
f1= 3;
f2 =10;         % 信号的频率成分
x = 0.5*cos(2*pi*f1*t) + sin(2*pi*f2*t)+randn(1,N);
subplot(2,2,1); % 绘制原始的信号
plot(t,x);
title('原始信号的时间域');
xlabel('时间/s');
y = fft(x);     % 对原信号作 FFT 变换
xlim([0 12]);
ylim([-1.5 1.5]);
subplot(2,2,2);
plot(f,abs(y)*2/N);     % 绘制原始信号的振幅谱
xlabel('频率/Hz');
ylabel('振幅');
xlim([0 50]);
title('原始振幅谱');
ylim([0 0.8]);
f1 =4;
f2 =8;                  % 要滤去频率的上限和下限
yy =zeros(1,length(y)); % 设置与 y 相同的元素数组
for m =0:N-1            % 将频率落在该频率范围及其大于Nyquist频率的波滤去
    % 小于 Nyquist 频率的滤波范围
    if (m/(N*dt) > f1 & m/(N *dt) <f2) | (m/(N*dt) >(1/dt -f2) & m/(N/dt) < (1/dt -f1));
    % 大于 Nyquist 频率的滤波范围
    % 1/dt 为一个频率周期
        yy(m+1) =0;     % 置在此频率范围内的振动振幅为零
    else
        yy(m+1) = y(m+1);   % 其余频率范围的振动振幅不变
    end
end

subplot(2,2,4);
plot(f,abs(yy)*2/N);    % 绘制滤波后的振幅谱
xlim([0 50]);
ylim([0 0.5]);
xlabel('频率/Hz');
ylabel('振幅');
gstext = sprintf('自 %4.1f -%4.1fHz 的频率被滤除',f1,f2);
% 将滤波范围显示作为标题
title(gstext);
subplot(2,2,3);
plot(t,real(ifft(yy)));
% 绘制滤波后的数据运用 ifft 变换回时间域并绘图
title('通过IFFT 回到时间域');
xlabel('时间/s');
ylim([-0.6 0.6]);
xlim([0 12]);
%}


% DCT 与 DCT反变换
%{
n = 0:200-1;
f = 200;fs = 3000;
x = cos(2*pi*n*f/fs);
y = dct(x);         % 计算DCT变换
m = find(abs(y<5)); % 利用阈值对变换系数截取
y(m) = zeros(size(m));
z = idct(y);        % 对门限处理后的系数DCT反变换
subplot(1,2,1);
plot(n,x);
xlabel('n');
title('序列x(n)');
subplot(1,2,2);
plot(n,z);
xlabel('n');
title('序列z(n)');
%}

% MATLAB 的 czt 函数实现频率细化
%{
fs = 256;                       % 采样频率
N =512;                         % 采样点数
nfft = 512;
n = 0:1:N-1;
% n/fs 采样频率下对应的时间序列值
n1 = fs*(0:nfft/2-1)/nfft;      % FFT 对应的频率序列
x = 3*sin(2*pi*100*n/fs) + 3*cos(2*pi*101.45*n/fs)+2*sin(2*pi*102.3*n/fs)+4 *cos(2*pi*103.8*n/fs)+5*sin(2*pi*104.5*n/fs);
figure;
subplot(231);
plot(n,x);
xlabel('时间t');
ylabel('value');
title('信号的时域波形');

XK = fft(x,nfft);               % 单边幅值谱
subplot(232);stem(n1,abs(XK(1:(nfft/2))));      % 用杆状来画 FFT 的图
axis([95,110,0,1500]);
title('直接利用FFT变换后的频谱');
subplot(233);plot(n1,abs(XK(1:N/2)));
axis([95,110,0,1500]);
title('直接利用FFT变换后的频谱');

f1 = 100;           % 细化频率段起点
f2 = 110;           % 细化频率段终点
M = 256;            % 细化频率段的频点数（这里其实就是细化精度）
w = exp(-j*2*pi*(f2-f1)/(fs*M));        % 细化频段的跨度（步长）
a = exp(j*2*pi*f1/fs);      % 细化频段的起始点，这里需要运算一下才能带入了 czt 函数
xk = czt(x,M,w,a);
h = 0:1:M-1;        % 细化频点序列
f0 = (f2-f1)/M*h+100;   % 细化的频率值
subplot(234);stem(f0,abs(xk));
xlabel('f');
ylabel('value');
title('利用CZT变换后的细化频谱');
subplot(235);plot(f0,abs(xk));
xlabel('f');
ylabel('value');
title('利用 CZT 变换后的细化频谱');
%}


% 利用 Chirp-Z 变换计算滤波器在 100~200Hz的频率特性，并比较 czt 和fft函数
%{
h = fir1(30,125/500,boxcar(31));
Fs = 1000;
f1 = 100;
f2 = 200;
m = 1024;
w = exp(-j*2*pi*(f2-1)/(m*Fs));
a = exp(j*2*pi*f1/Fs);
y = fft(h,m);
z = czt(h,m,w,a);
fy = (0:length(y)-1)'* Fs/length(y);
fz = (0:length(z)-1)'*(f2-f1)/length(z)+f1;
subplot(2,1,1);
plot(fy(1:500),abs(y(1:500)));
title('fft');
subplot(2,1,2);
plot(fz,abs(z));
title('czt');
%}


% 用Gabor 函数分析 双时间信号
%{
a = 1/10;
m =2;
t1 =5;t2 =6;
% 设定双信号的位置
% 绘制双信号的三维网格立体图
[t,W] = meshgrid([2:0.2:7],[0:pi/6:3*pi]);
%设置时-频相平面网格点
Gs1 = (1/(sqrt(2*pi)*a)) *exp(-0.5 *abs((t1-t)/a).^m).*exp(-i*W*t1);
Gs2 = (1/(sqrt(2*pi)*a)) *exp(-0.5 *abs((t2-t)/a).^m).*exp(-i*W*t2);
Gs = Gs1+Gs2;
subplot(2,3,1);
% 绘制实部三维网格立体图
mesh(t,W/pi,real(Gs));
axis([2 7 0 3 -1/(sqrt(2*pi)*a) 1/(sqrt(2*pi)*a)]);
title('实部');
xlabel('t(s)');ylabel('real(Gs)');
subplot(2,3,2);
% 绘制虚部三维网格立体图
axis([2 7 0 3 -1/(sqrt(2*pi)*a) 1/(sqrt(2*pi)*a)]);
title('虚部');
xlabel('t(s)');ylabel('imag(Gs)');
subplot(2,3,3);
% 绘制绝对值三维网格立体图
mesh(t,W/pi,abs(Gs));
axis([2 7 0 3 -1/(sqrt(2*pi)*a) 1/(sqrt(2*pi)*a)]);
title('绝对值');
xlabel('t(s)');ylabel('abs(Gs)');
% 绘制双信号的二维灰度图
[t,W] = meshgrid([2:0.2:7],[0:pi/20:3*pi]);
% 设置时频相平面网格点
Gs1 = (1/(sqrt(2*pi)*a)) *exp(-0.5 *abs((t1-t)/a).^m).*exp(-i*W*t1);
Gs2 = (1/(sqrt(2*pi)*a)) *exp(-0.5 *abs((t2-t)/a).^m).*exp(-i*W*t2);
Gs = Gs1+Gs2;
subplot(2,3,4);
ss = real(Gs);ma = max(max(ss));
% 计算最大值
pcolor(t,W/pi,ma-ss);
title('实部最大值');
xlabel('t(s)');ylabel('maxreal(Gs)');
colormap(gray(50));shading interp;
subplot(2,3,5);
ss = imag(Gs);ma = max(max(ss));
% 计算最大值
pcolor(t,W/pi,ma-ss);
title('虚部最大值');
xlabel('t(s)');ylabel('maximag(Gs)');
colormap(gray(50));shading interp;
subplot(2,3,6);
ss = abs(Gs);ma = max(max(ss));
% 计算绝对值的最大值
pcolor(t,W/pi,ma-ss);
title('绝对值最大值');
xlabel('t(s)');ylabel('maxabs(Gs)');
colormap(gray(50));shading interp;
%}


% 利用Gabor 展开检测信号的频谱
%{
t =40;
fs = 10000;
f1 = 2000;
f2 =4000;
le = fs*t;
a = 1/16;b = 16;
N = a* fs;
M = fs/b;
s = fix(le/fs);
% 帧间重叠 1/2,算出所需循环次数
hn = boxcar(M)';
% 得到STFT分析窗，汉宁窗，帧长 256点
T = 1:fs*t;
d = sin(2*pi*f1*T/fs) + sin(2*pi*f2*T/fs);
for n = 1:1:s
        d1(1:M) = d((n-1)*N + 1:(n-1)*N+M).*hn;
         % 时域加窗
         Xd(n,(1:M)) = fft(d1,M);   % FFT
end
[n,m] = size(Xd);
x = 1:n;y=1:m;
mesh(y/m,x,abs(Xd));
axis([0,0.5,0,20,0,100]);
xlabel('t');
ylabel('f');
zlabel('幅度');
%}


% Gabor 的 MATLAB实现
fs = 100;
% 采样率
Ts = 1/fs;
t = 0:Ts:10;
gass = 2^(1/4)*exp(-pi*(t).^2).*cos(5*pi*t);
% 生成一个高斯函数
subplot(231);
plot(t,gass);
title('高斯函数');
xlabel('t');
ylabel('幅度');
grid on;
T=0:Ts:10;
ft = sin(T.^2 + 2*T) +sin(T.^2);
% 生成要变换的信号函数
subplot(232);
plot(t,ft);
title('信号函数');
grid on;
xlabel('t');
ylabel('幅度');
y = fft(ft);
% 信号做 FFT 变换
amp = abs(y);
grid on;
subplot(233);
plot(amp);
title('信号的FFT变换');
xlabel('f');
ylabel('幅度');
grid on;
subplot(234);
plot(t,imag(hilbert(ft)));
title('信号的HHT变换');
grid on;
shl = 100;
% 高斯窗每次平移点数
shn = (length(t) -1)/shl;
% 求高斯窗平移总次数
y2 = zeros(shn,2001);
for k =0:shn-1
    gassc = 2^(1/4) *exp(-pi*(t-k*shl*Ts).^2).*cos(5*pi*t);
    %平移后的高斯函数
    gassc2 = gassc /sum(gassc.^2);
    % 归一化
    yl = conv(hilbert(ft),gassc2);
    % 短时傅里叶变换，即对信号与 Gauss 函数做卷积
    y2(k+1,:) = yl;
end
[F,T] = size(y2);
[F,T] = meshgrid(1:T,1:F);
subplot(235);
mesh(F,T,abs(y2));
title('信号尺度分布图');
xlabel('t');
ylabel('f');
zlabel('幅度');
subplot(236);
contour(F,T,abs(y2));
% 等高线图
title('信号时频图');
xlabel('F(Hz)');
ylabel('尺度');
