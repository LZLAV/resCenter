% fir 滤波器示例
clear;
close all;
clc;

%直接型
%{
n = 0:10;
N = 30;
b = 0.9.^n;
delta = impseq(0,0,N);
h = filter(b,1,delta);
x = [ones(1,5),zeros(1,N-5)];
y = filter(b,1,x);
subplot(2,2,1);
stem(h);
title('直接型h(n)');
subplot(2,2,2);stem(y);
title('直接型y(n)');
[b0,B,A] = dir2cas(b,1);
h = casfilter(b0,B,A,delta);
y = casfilter(b0,B,A,x);
subplot(2,2,3);stem(h);
title('级联型');
subplot(2,2,4);stem(y);
title('级联型y(n)');
%}

% 利用频率采样发设计一个低通FIR 数字低通滤波器，其理想频率特性是矩形的，给定采样频率为 2*pi%1.5*10^4
% 截止频率为 2*pi*1.6*10^3 ,阻带起始频率为 2*pi*3.1*10^3，通带波动 <= 1dB,阻带衰减 >= 50dB
%{
N = 30;
H = [ones(1,4),zeros(1,22),ones(1,4)];
H(1,5) = 0.5886;
H(1,26)=0.5886;
H(1,6) = 0.1065;
H(1,25) = 0.1065;
k = 0:(N/2-1);k1 = (N/2+1):(N-1);k2 =0;
A = [exp(-j*pi*k*(N-1)/N),exp(-j*pi*k2*(N-1)/N),exp(j*pi*(N-k1)*(N-1)/N)];
HK = H.*A;
h = ifft(HK);
fs = 15000;
[c,f3] = freqz(h,1); 
f3 = f3/pi *fs/2;
subplot(221);
plot(f3,20*log10(abs(c)));
title('频谱特性');
xlabel('频率/Hz');ylabel('衰减/dB');
grid on;
subplot(222);
title('输入采样波形');
stem(real(h),'.');
line([0,35],[0,0]);
xlabel('n');
ylabel('Real(h(n))');
grid on;
t = (0:100)/fs;
W = sin(2*pi*t*750) + sin(2*pi*t*3000)+sin(2*pi*t*6500);
q = filter(h,1,W);
[a,f1] = freqz(W);
f1 = f1/pi*fs/2;
[b,f2] = freqz(q);
f2 = f2/pi*fs/2;
subplot(223);
plot(f1,abs(a));
title('输入波形频谱图');
xlabel('频率');
ylabel('幅度');
grid on;
subplot(224);
plot(f2,abs(b));
title('输出波形频谱图');
xlabel('频率');
ylabel('幅度');
grid on;
%}

% 一个 20点相位 FIR 系统的频率样本的频率采样型结构
%{
M = 20;
alpha = (M-1)/2;
magHK = [1 1 1 0.5 zeros(1,13) 0.5 1 1];
k1 = 0:10;
k2 = 11:M-1;
angHK = [-alpha*2*pi/M*k1,alpha*2*pi/M*(M-k2)];
H = magHK.*exp(j*angHK);
h = real(ifft(H,M));
[C,B,A] = dir2fs(h)
%}


% I型线性相位滤波器
%{
h = [-4 3 -5 -2 5 7 5 -2 -1 8 -3];
M = length(h);
n = 0:M-1;
[Hr,w,a,L] = hr_type1(h);
subplot(2,2,1);
stem(n,h);
xlabel('n');
ylabel('h(n)');
title('冲激响应');
grid on;
subplot(2,2,3);
stem(0:L,a);
xlabel('n');
ylabel('a(n)');
title('a(n)系数');
grid on;
subplot(2,2,2);
plot(w/pi,Hr);
xlabel('频率单位pi');
ylabel('Hr');
title('I型幅度响应');
grid on;
subplot(2,2,4);
pzplotz(h,1);
grid on;
%}


% II型线性相位滤波器
%{
h = [-4 3 -5 -2 5 7 5 -2 -1 8 -3];
M = length(h);
n = 0:M-1;
[Hr,w,b,L] = hr_type2(h);
subplot(2,2,1);
stem(n,h);
xlabel('n');
ylabel('h(n)');
title('冲激响应');
grid on;
subplot(2,2,3);
stem(1:L,b);
xlabel('n');
ylabel('b(n)');
title('b(n)系数');
grid on;
subplot(2,2,2);
plot(w/pi,Hr);
xlabel('频率单位pi');
ylabel('Hr');
title('II型幅度响应');
grid on;
subplot(2,2,4);
pzplotz(h,1);
grid on;
%}

% III型线性相关滤波器
%{
h = [-4 3 -5 -2 5 7 5 -2 -1 8 -3];
M = length(h);
n = 0:M-1;
[Hr,w,c,L] = hr_type3(h);
subplot(2,2,1);
stem(n,h);
xlabel('n');
ylabel('h(n)');
title('冲激响应');
grid on;
subplot(2,2,3);
stem(0:L,c);
xlabel('n');
ylabel('c(n)');
title('c(n)系数');
grid on;
subplot(2,2,2);
plot(w/pi,Hr);
xlabel('频率单位pi');
ylabel('Hr');
title('III型幅度响应');
grid on;
subplot(2,2,4);
pzplotz(h,1);
grid on;
%}


% IV 型线性相关滤波器
%{
h = [-4 3 -5 -2 5 7 5 -2 -1 8 -3];
M = length(h);
n = 0:M-1;
[Hr,w,d,L] = hr_type4(h);
subplot(2,2,1);
stem(n,h);
xlabel('n');
ylabel('h(n)');
title('冲激响应');
grid on;
subplot(2,2,3);
stem(1:L,d);
xlabel('n');
ylabel('d(n)');
title('d(n)系数');
grid on;
subplot(2,2,2);
plot(w/pi,Hr);
xlabel('频率单位pi');
ylabel('Hr');
title('III型幅度响应');
grid on;
subplot(2,2,4);
pzplotz(h,1);
grid on;
%}

% 四类线性相位低通滤波器的幅度响应
%{
h1 = [-3,1,-1,-2,5,6,5,-2,-1,1,-3];
h2 = [-3,1,-1,-2,5,6,6,5,-2,-1,1,-3];
h3 = [-3,1,-1,-2,5,0,-5,2,1,-1,3];
h4 = [-3,1,-1,-2,5,6,-6,-5,2,1,-1,3];
[A1,w1,a1,L1] = amplres(h1);
[A2,w2,a2,L2] = amplres(h2);
[A3,w3,a3,L3] = amplres(h3);
[A4,w4,a4,L4] = amplres(h4);
figure(1);
n1 =0:length(h1)-1;
amax = max(h1)+1;amin = min(h1)-1;
subplot(241);
stem(n1,h1,'k');
axis([-1 2*L1+1 amin amax]);
text(5,-6,'n');
ylabel('h(n)');
title('冲激响应');
subplot(242);
plot(w1,A1,'k');
grid on;
text(4,-18,'w');
ylabel('A(\omega)');
title('I型幅度响应');
n2 =0:length(h2)-1;
amax = max(h2) +1;
amin = min(h2) -1;
subplot(243);
stem(n2,h2,'k');
axis([-1 2*L2+1 amin amax]);
text(5,-6,'n');
ylabel('h(n)');
title('冲激响应');
subplot(244);plot(w2,A2,'k');
grid on;text(4,-28,'w');
ylabel('A(\omega)');
title('II型幅度响应');
n3 =0:length(h3) -1;
amax = max(h3) +1;
amin = min(h3) -1;
subplot(245);
stem(n3,h3,'k');
axis([-1 2*L3+1 amin amax]);
text(5,-7,'n');
ylabel('h(n)');
title('冲激响应');
subplot(246);
plot(w3,A3,'k');
grid on;
text(4,-28,'w');
ylabel('A(\omega)');
title('III型幅度响应');
n4 =0:length(h4)-1;
amax = max(h4)+1;
amin = min(h4)-1;
subplot(247);
stem(n4,h4,'k');
axis([-1 2*L4+1 amin amax]);
text(5,-8,'n');
ylabel('h(n)');
title('冲激响应');
subplot(248);
plot(w4,A4,'k');
grid on;
text(4,-12,'w');
ylabel('A(\omega)');
title('IV型幅度响应');
%}

% 四种滤波器的零极点图
%{
h1 = [-4,2,-2,-2,5,7,5,-2,-2,2,-4];
h2 = [-4,2,-2,-2,5,7,7,5,-2,-2,2,-4];
h3 = [-4,2,-2,-2,5,0,-5,2,2,-2,4];
h4 = [-4,2,-2,-2,5,7,-7,-5,2,2,-2,4];
subplot(2,2,1);
zplane(h1,1);
title('I型零极点');
subplot(2,2,2);
zplane(h2,1);title('II型零极点');
subplot(2,2,3);
zplane(h3,1);
title('III型零极点');
subplot(2,2,4);
zplane(h4,1);
title('III型零极点');
%}

% 矩形窗示例
%{
n = 60;
w = rectwin(n);
wvtool(w);
%}


% 运用矩形窗函数设计FIR 带阻滤波器         ??????????
%{
Wph = 3*pi*6.25/15;
Wpl = 3*pi/15;
Wsl = 3*pi*2.5/15;
Wsh = 3*pi*4.75/15;
tr_width = min((Wsl-Wpl),(Wph-Wsh));
% 过渡带宽度
N = ceil(4*pi/tr_width);        % 滤波器长度
n = 0:1:N-1;
Wcl = (Wsl+Wpl)/2;              % 理想滤波器的截止频率
Wch = (Wsh+Wph)/2;
hd = ideal_bs(Wcl,Wch,N);       % 理想滤波器的单位冲激响应
w_ham = (boxcar(N));
string = ['矩形窗','N =',num2str(N)];
h = hd.* w_ham;                 % 截取取得实际的单位冲激响应
[db,mag,pha,w] = freqz_m2(h,[1]);
% 计算实际滤波器的幅度响应
delta_w = 2*pi/1000;
subplot(241);
stem(n,hd);
title('理想冲激响应 hd(n)');
axis([-1,N,-0.5,0.8]);
xlabel('n');ylabel('hd(n)');
grid on;
subplot(242);
stem(n,w_ham);
axis([-1,N,0,1.1]);
xlabel('n');
ylabel('w(n)');
text(1.5,1.3,string);
grid on;
subplot(243);
stem(n,h);title('实际冲激响应h(n)');
axis([0,N,-1.4,1.4]);
xlabel('n');ylabel('h(n)');
grid on;
subplot(244);
plot(w,pha);title('相频特性');
axis([0,3.15,-4,4]);
xlabel('频率(rad)');
ylabel('相位()');
grid on;
subplot(245);
plot(w/pi,db);title('幅度特性(dB)');
axis([0,1,-80,10]);
xlabel('频率(pi)');
ylabel('分贝数');
grid on;
subplot(246);
plot(w,mag);title('频率特性');
axis([0,3,0,2]);
xlabel('频率(rad)');ylabel('幅值');
grid on;
fs = 15000;
t = (0:100)/fs;
x = cos(2*pi*t*750) +cos(2*pi*t*3000)+cos(2*pi*t*6100);
q = filter(h,1,x);
[a,f1] = freqz(x);
f1 = f1/pi*fs/2;
[b,f2] = freqz(q);
f2 = f2/pi*fs/2;
subplot(247);
plot(f1,abs(a));
title('输入波形频谱图');
xlabel('频率');
ylabel('幅度');
grid on;
subplot(248);
plot(f2,abs(b));
title('输出波形频谱图');
xlabel('频率');
ylabel('幅度');
grid on;
%}

% 汉宁窗实例
%{
N = 49;n=1:N;
wdhn = hanning(N);
figure(3);
stem(n,wdhn,'.');
grid on;
axis([0,N,0,1.1]);
title('50点汉宁窗');
ylabel('W(n)');
xlabel('n');
title('50点汉宁窗');
%}


% 信号加矩形窗和汉宁窗比较
%{
N= 60;
L = 512;
f1 = 100;f2 = 150;fs = 600;
ws = 2*pi*fs;
t = (0:N-1)*(1/fs);
x = cos(2*pi*f1*t) +0.25*sin(2*pi*f2*t);
subplot(231);
stem(t,x);
title('原信号1时域图');
wh = boxcar(N)';
x = x.*wh;
subplot(232);
stem(t,x);
title('加矩形窗时域图');
xlabel('n');
ylabel('h(n)');
grid on;
W = fft(x,L);
f = ((-L/2:L/2-1) * (2*pi/L)*fs)/(2*pi);
subplot(233);
plot(f,abs(fftshift(W)));
title('加矩形窗频域图');
xlabel('频率');ylabel('幅度');
grid on;
x = cos(2*pi*f1*t) +0.15*cos(2*pi*f2*t);
subplot(234);
stem(t,x);
title('原信号2时域图');
wh = hanning(N)';
x = x.*wh;
subplot(235);stem(t,x);
title('加汉宁窗时域图');
xlabel('n');ylabel('h(n)');
grid on;
W =fft(x,L);
f = ((-L/2:L/2-1) * (2*pi/L)*fs)/(2*pi);
subplot(236);
plot(f,abs(fftshift(W)));
title('加汉宁窗频域图');
xlabel('频率');
ylabel('幅度');
grid on;
%}

% 海明窗实例
%{
L = 64;
wvtool(hamming(L));
%}


% 用海明窗设计低通滤波器
%{
wd = 0.875*pi;
N = 133;M = (N-1)/2;
nn = -M:M;
n = nn+eps;
hd = sin(wd*n)./(pi*n);     % 理想冲激响应
w = hamming(N)';             % 海明窗
h = hd.*w;                  % 实际冲激响应
H = 20*log10(abs(fft(h,1024)));     % 实际滤波器的分贝幅度特性
HH = [H(513:1024) H(1:512)];
subplot(221);plot(nn,hd,'k');
xlabel('n');title('理想冲激响应');axis([-70 70 -0.1 0.3]);
subplot(222);plot(nn,w,'k');axis([-70 70 -0.1 1.2]);
title('海明窗');xlabel('n');
subplot(223);plot(nn,h,'k');
axis([-70 70 -0.1 0.3]);
xlabel('n');title('实际冲激响应');
w = (-512:511)/511;
subplot(224);plot(w,HH,'k');
axis([-1.2 1.2 -140 20]);xlabel('\omega/\pi');title('滤波器分贝幅度特性');
set(gcf,'color','w');
%}


% 用海明窗设计高通滤波器
%{
wd = 0.6*pi;N = 65;M = (N-1)/2;
nn = -M:M;
n = nn+eps;
hd = 3*((-1).^n).*tan(wd*n)./(pi*n);        % 理想冲激响应
w = hamming(N)';        % 海明窗
h = hd.*w;      % 实际冲激响应
H = 20*log10(abs(fft(h,1024)));
HH = [H(513:1024) H(1:512)];
subplot(221);stem(nn,hd,'k');
xlabel('n');
title('理想冲激响应');
axis([-18 18 -0.8 1.2]);
subplot(222);stem(nn,w,'k');axis([-18 18 -0.1 1.2]);
title('海明窗');xlabel('n');
subplot(223);stem(nn,h,'k');
axis([-18 18 -0.8 1.2]);xlabel('n');title('实际冲激响应');
w = (-512:511)/511;
subplot(224);plot(w,HH,'k');
axis([-1.2 1.2 -140 20]);xlabel('\omega/\pi');title('滤波器分贝幅度特性');
set(gcf,'color','w');
%}

% 利用布莱克曼窗函数设计数字带通滤波器
%{
wp1  = 0.4*pi;
wp2 = 0.6*pi;
ws1 = 0.3*pi;
ws2 = 0.7*pi;
As = 150;
tr_width = min((wp1-ws1),(ws2-wp2));        % 过渡带宽度
M = ceil(11*pi/tr_width)+1;     % 滤波器长度
n = [0:1:M-1];
wc1 = (ws1+wp1)/2;      % 理想带通滤波器的下截止频率
wc2 = (ws2+wp2);        % 理想带通滤波器的上截止频率
hd = ideal_lp(wc2,M) - ideal_lp(wc1,M);
w_bla = (blackman(M))';     % 布莱克曼窗
h = hd.*w_bla;
% 截取得到实际的单位冲激响应
[db,mag,pha,grd,w] = freqz_m(h,[1]);        % ????????????????
% 计算实际滤波器的幅度响应
delta_w = 2*pi/1000;
Rp = -min(db(wp1/delta_w+1:1:wp2/delta_w));
% 实际通带滤波
As = -round(max(db(ws2/delta_w+1:1:50)));
As = 150;
subplot(2,2,1);
stem(n,hd);
title('理想单位冲激响应hd(n)');
axis([0 M-1 -.04 0.5]);
xlabel('n');ylabel('hd(n)');
grid on;
subplot(2,2,2);stem(n,w_bla);
title('布莱克曼窗w(n)');
axis([0 M-1 0 1.1]);
xlabel('n');ylabel('w(n)');
grid on;
subplot(2,2,3);
stem(n,h);
title('实际单位冲激响应hd(n)');
axis([0 M-1 -0.4 0.5]);
xlabel('n');
ylabel('h(n)');
grid on;
subplot(2,2,4);
plot(w/pi,db);
axis([0 1 -150 10]);
title('幅度响应(dB)');
grid on;
xlabel('频率单位:pi');
ylabel('分贝数');
%}

% 巴特窗--三角窗示例
%{
w1 = bartlett(7);       % 三角窗(巴特窗效果)
w2 = bartlett(8);       % 梯形三角窗
wvtool(w1);
wvtool(w2);
%}

% 设计巴特窗
%{
Nwin = 20;      % 数据总数
n = 0:Nwin-1;       % 数据序列序号
w = bartlett(Nwin);
subplot(131);stem(n,w);     % 绘出窗函数
xlabel('n');ylabel('w(n)');
grid on;
Nf = 512;       % 窗函数复数频率特性的数据点数
Nwin = 20;      % 窗函数数据长度
[y,f] = freqz(w,1,Nf);
mag = abs(y);       % 求得窗函数幅频特性
w = bartlett(Nwin);
subplot(132);plot(f/pi,20*log10(mag/max(mag))); % 绘制窗函数的幅频特性
xlabel('归一化频率');
ylabel('振幅/dB');
grid on;
w = blackman(Nwin);
[y,f] = freqz(w,1,Nf);
mag = abs(y);                                       % 求得窗函数幅频特性
subplot(133);plot(f/pi,20*log10(mag/max(mag)));     % 绘制窗函数的幅频特性
xlabel('归一化频率');
ylabel('振幅/dB');
grid on;
%}

% 利用凯塞窗函数设计一个带通滤波器示例
%{
Fs = 8000;N = 216;
fcuts = [1000 1200 2300 2500];
mags = [0 1 0];
devs =[0.02 0.1 0.02];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,Fs);
n = n+rem(n,2);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
[H,f] = freqz(hh,1,N,Fs);
plot(f,abs(H));
xlabel('频率(Hz)');
ylabel('幅值|H(f)|');
grid on;
%}

% 设计一个 40 阶的带通 FIR 滤波器，采用巴特窗，采样频率为10kHz,两个截止频率分别为为 2kHz 和3kHz
%{
h = usefir1(3,60,2000,3000,3,2,10000);
%}


% 频率采样法低通滤波器示例
%{
N = 33;
wc = pi/3;
N1 =fix(wc/(2*pi/N));
A = [zeros(1,N1),0.5304,ones(1,N1),0.5304,zeros(1,N1*2-1),0.5304,ones(1,N1),0.5304,zeros(1,N1)];
theta = -pi*[0:N-1]*(N-1)/N;
H = A.*exp(j*theta);
h = real(ifft(H));v = 1:N;
subplot(2,2,1);plot(v,A,'k*');
title('频率样本');ylabel('H(k)');
axis([0,fix(N*1.1),-0.1,1.1]);
subplot(2,2,2);stem(v,h,'k');
title('冲激响应');ylabel('H(k)');
axis([0,fix(N*1.1),-0.3,0.4]);
M = 500;
nx = [1:N];
w = linspace(0,pi,M);
X = h*exp(-j*nx'*w);
subplot(2,2,3);
plot(w./pi,abs(X),'k');
xlabel('\omega/\pi');ylabel('Hd\omega');
axis([0,1,-0.1,1.3]);title('幅度响应');
subplot(2,2,4);
plot(w./pi,20*log10(abs(X)),'k');
title('幅度响应');
xlabel('\omega/\pi');
ylabel('dB');
axis([0,1,-80,10]);
%}


% 频率采样法高通滤波器    ?????????????
%{
wp = 0.8*pi;ws = 0.6*pi;
Rp =1;As = 60;
M = 33;alpha = (M-1)/2; l =0:M-1;w1 = (2*pi/M)*l;
Hrs = [zeros(1,11),0.1187,0.473,ones(1,8),0.473,0.1187,zeros(1,10)];
Hdr = [0 0 1 1];wdl = [0 0.6 0.8 1];
k1 = 0:floor((M-1)/2);k2 = floor((M-1)/2)+1:M-1;
angH = [-alpha*(2*pi)/M*k1,alpha*(2*pi)/M*(M-k2)];
H = Hrs.*exp(j*angH);
h = real(ifft(H,M));
[db,mag,pha,grd,w] = freqz_m(h,1);
[Hr,ww,a,L] = hr_type(h);
subplot(1,1,1);
subplot(2,2,1);plot(w1(1:17)/pi,Hrs(1:17),'o',wd1,Hdr);
axis([0,1,-0.1,1.1]);title('高通：M=33，T1=0.1187,T2=0.473');
xlabel('');ylabel('Hr(k)');
set(gca,'XTickMode','manual','Xtick',[0;6;8;1]);
set(gca,'XTickLabelMode','manual','XTickLabels',['0';'.6';'.8';'1']);
grid on;
subplot(2,2,2);stem(l,h);axis([-1,M,-0.4,0.4]);
title('冲激响应');ylabel('h(n)');text(M+1,-0.4,'n');
subplot(2,2,3);plot(ww/pi,Hr,w1(1:17)/pi,Hrs(1:17),'o');
xlabel('频率/pi');ylabel('Hr(w)');
set(gca,'XTickMode','manual','XTick',[0,.6,.8,1]);
set(gca,'XTickLabelMode','manual','XTickLabels',['0';'.6';'.8';'1']);
grid on;
subplot(2,2,4);plot(w/pi,db);
axis([0 1 -100 10]);
grid on;title('幅度响应');
xlabel('频率/pi');ylabel('分贝数');
set(gca,'XTickMode','manual','XTick',[0;.6;.8;1]);
set(gca,'XTickLabelMode','manual','XTickLabels',['0';'.6';'.8';'1']);
set(gca,'YTickMode','manual','YTick',[-50;0]);
set(gca,'YTickLabelMode','manual','YTickLabels',['50';'0']);
%}


% 利用 remez 函数设计低通等波纹滤波器
%{
n = 40;         % 滤波器的阶数
f = [0 0.5 0.6 1];  % 频率向量
a = [1 2 0 0];      % 振幅向量
w = [1 20];
b = firls(n,f,a,w);
[h,w1] = freqz(b);      % 计算滤波器的频率响应
bb = remez(n,f,a,w);    % 采用 remez 设计滤波器
[hh,w2] = freqz(bb);    % 计算滤波器的频率响应
figure;
plot(w1/pi,abs(h),'r.',w2/pi,abs(hh),'b-.',f,a,'ms');
% 绘制滤波器幅频响应
xlabel('归一化频率');
ylabel('振幅');
%}


% 利用切比雪夫逼近设计法设计低通滤波器   ?????????????
%{
wp = 0.4*pi;
ws = 0.6*pi;
Rp = 0.45;
As = 80;
% 给定指标
delta1 = (10^(Rp/20)-1)/(10^(Rp/20)+1);
delta2 = (1+delta1) *(10^(-As/20));
% 求波动指标
weights = [delta2/delta1 1];
deltaf = (ws-wp)/(2*pi);
% 给定权函数 和 wp-ws
N = ceil((-20*log10(sqrt(delta1*delta2))-13)/(14.6*deltaf)+1);
N = N+mod(N-1,2);
% 估算阶数N
f = [0 wp/pi ws/pi 1];
A = [1 1 0 0];
% 给定频率点和希望幅度值
h = remez(N-1,f,A,weights);
% 求冲激响应
[db,mag,pha,grd,W] = freqz_m(h,[1]);
% 验证求取频率特性
delta_w = 2*pi/1000;
wsi = ws/delta_w +1;
wpi = wp/delta_w +1;
Asd = -max(db(wsi:1:500));
% 求阻带衰减
subplot(2,2,1);n =0:1:N-1;stem(n,h);
axis([0,52,-0.1,0.3]);title('脉冲响应');
xlabel('n');
ylabel('hd(n)');
grid on;
% 画h(n)
subplot(2,2,2);
plot(W,db);
title('对数幅频特性');
ylabel('分贝数');
xlabel('频率');
grid on;
% 画对数幅频特性
subplot(2,2,3);
plot(W,mag);axis([0,4,-0.5,1.5]);
title('绝对幅频特性');
xlabel('Hr(w)');
ylabel('频率');
grid on;
% 画绝对幅频特性
n = 1:(N-1)/2+1;
H0 = 2*h(n)*cos(((N+1)/2-n)'*W)-mod(N,2)*h((N-1)/2+1);
% 求 Hg(w)
subplot(2,2,4);
plot(W(1:wpi),H0(1:wpi)-1,W(wsi+5:501),H0(wsi+5:501));
title('误差特性');
% 求误差
ylabel('Hr(w)');
xlabel('频率');
grid on;
%}




