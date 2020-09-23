clear;
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