clear;
clc;
% 巴特沃斯滤波器的基本使用
%{
[Z,P,K] = buttap(20);
[num,den] = zp2tf(Z,P,K);
freqs(num,den);
%}

% 巴特沃斯低通滤波器幅频特性曲线
%{
n = 0:0.01:2;
for i=1:4
    switch i
        case 1
            N = 1;
        case 2
            N =3;
        case 3
            N =8;
        case 4
            N = 12;
    end
    [z,p,k] = buttap(N);    % 函数调用
    [b,a] = zp2tf(z,p,k);   % 得到传递函数
    [h,w] = freqs(b,a,n);   % 特性分析
    magh = abs(h);
    subplot(2,2,i);plot(w,magh);
    axis([0 2 0 1]);
    xlabel('w/wc');
    ylabel('|H(jw)|^2');
    title(['filter N =',num2str(N)]);
    grid on;
end
%}

% 巴特沃斯滤波器设计低通滤波器
%{
fn = 10000;
fp = 2000;
fs = 3000;
Rp =4;
Rs = 30;
Wp = fp/(fn/2); % 计算归一化角频率
Ws = fs/(fn/2);
[n,Wn] = buttord(Wp,Ws,Rp,Rs);disp(n);disp(Wn);
% 计算阶数和截止频率
[b,a] = butter(n,Wn);
% 计算H(z) 的分子、分母多项式系数
[H,F] = freqz(b,a,1000,8000);
% 计算H(z) 的幅频响应，freqz(b,a,计算点数,采样速率)
subplot(121);
plot(F,20*log10(abs(H)));
xlabel('频率(Hz)');
ylabel('幅值(dB)');
title('低通滤波器');
axis([0 4000 -30 3]);
grid on;
subplot(122);
pha = angle(H)*180/pi;
plot(F,pha);
xlabel('频率(Hz)');
ylabel('相位');
grid on;
%}

% 巴特沃斯滤波器设计高通滤波器
%{
fn = 10000;
fp = 900;
fs = 600;
Rp = 3;
Rs = 20;
Wp = fp/(fn/2);  % 计算归一化角频率
Ws = fs/(fn/2);
[n,Wn] = buttord(Wp,Ws,Rp,Rs);
% 计算阶数和截止频率
[b,a] = butter(n,Wn,'high');
% 计算H(z)分子、分母多项式系数
[H,F] = freqz(b,a,900,10000);
% 计算 H(z) 的幅频响应，freqz(b,a,计算点数,采样速率)
subplot(121);
plot(F,20*log10(abs(H)));
axis([0 4000 -30 3]);
xlabel('频率(Hz)');
ylabel('幅值(dB)');
grid on;
subplot(122);
pha = angle(H) * 180/pi;
plot(F,pha);
xlabel('频率(Hz)');
ylabel('相位');
grid on;
%}

% 巴特沃斯滤波器设计带通滤波器
%{
fn = 10000;
fp = [900,1200];
fs = [600,1700];
Rp =4;
Rs = 30;
Wp = fp/(fn/2); % 计算归一化角频率
Ws = fs/(fn/2);
[n,Wn] = buttord(Wp,Ws,Rp,Rs);
% 计算阶数和截止频率
[b,a] = butter(n,Wn);
% 计算H(z)分子、分母多项式系数
[H,F] = freqz(b,a,1000,10000);
% 计算H(z) 的幅频响应，freqz(b,a,计算点数,采样速率)
subplot(121);
plot(F,20*log10(abs(H)));
axis([0 5000 -30 3]);
xlabel('频率(Hz)');
ylabel('幅值(dB)');
grid on;
subplot(122);
pha = angle(H) * 180/pi;
plot(F,pha);
xlabel('频率(Hz)');
ylabel('相位');
grid on;
%}

% 巴特沃斯滤波器设计带阻滤波器
%{
fn = 10000;
fp = [600,1700];
fs = [900,1200];
Rp =4;
Rs = 30;
Wp = fp/(fn/2); % 计算归一化角频率
Ws = fs/(fn/2);
[n,Wn] = buttord(Wp,Ws,Rp,Rs);
% 计算阶数和截止频率
[b,a] = butter(n,Wn,'stop');
% 计算H(z)分子、分母多项式系数
[H,F] = freqz(b,a,1000,10000);
% 计算H(z) 的幅频响应，freqz(b,a,计算点数,采样速率)
subplot(121);
plot(F,20*log10(abs(H)));
axis([0 5000 -30 3]);
xlabel('频率(Hz)');
ylabel('幅值(dB)');
grid on;
subplot(122);
pha = angle(H) * 180/pi;
plot(F,pha);
xlabel('频率(Hz)');
ylabel('相位');
grid on;
%}


% 切比雪夫I型低通滤波器幅频响应曲线
%{
Wp = 3*pi*4*12^3;
Ws = 3*pi*12*10^3;
rp =1;
rs = 30;        % 设计滤波器的参数
wp = 1; 
ws = Ws/Wp;     % 对参数归一化
[N,wc] = cheb1ord(wp,ws,rp,rs,'s'); % 计算滤波器阶数和阻带起始频率
[z,p,k] = cheb1ap(N,rs);        % 计算零点、极点、增益
[B,A] = zp2tf(z,p,k);
w = 0:0.002*pi:pi;
[h,w] = freqs(B,A,w);
plot(w*wc/wp,20*log10(abs(h)),'k');
grid on;
xlabel('\lambda');
ylabel('A(\lambda)/dB');
%}

% 切比雪夫I型低通滤波器的平方幅频响应曲线
%{
n = 0:0.02:4;
for i =1:4
    switch i
        case 1,N = 1;
        case 2,N = 3;
        case 3,N = 5;
        case 4,N = 7;
    end
    Rp = 1;                         % 设置通滤波纹为 1dB
    [z,p,k] = cheb1ap(N,Rp);        % 设计 Chebyshev I 型滤波器
    [b,a] = zp2tf(z,p,k);           % 将零点极点增益形式转换为传递函数形式
    [H,w] = freqs(b,a,n);           % 按 n 指定的频率点给出频率响应
    magH2 = (abs(H)).^2;            % 给出传递函数幅度平方
    subplot(2,2,i);
    plot(w,magH2);
    title (['N=' num2str(N)]);
    xlabel('w/wc');
    ylabel('切比雪夫I型 |H(jw)|^2');
    grid on;
end
%}

% 切比雪夫II型低通滤波器幅频响应曲线
%{
Wp = 3*pi*4*12^3;
Ws = 3*pi*12*10^3;
rp =1;
rs = 30;        % 设计滤波器的参数
wp = 1; 
ws = Ws/Wp;     % 对参数归一化
[N,wc] = cheb2ord(wp,ws,rp,rs,'s'); % 计算滤波器阶数和阻带起始频率
[z,p,k] = cheb2ap(N,rs);        % 计算零点、极点、增益
[B,A] = zp2tf(z,p,k);
w = 0:0.002*pi:pi;
[h,w] = freqs(B,A,w);
plot(w*wc/wp,20*log10(abs(h)),'k');
grid on;
xlabel('\lambda');
ylabel('A(\lambda)/dB');
%}


% 切比雪夫II型滤波器的平方幅频响应曲线
%{
n = 0:0.02:4;   % 频率点
for i =1:4      % 取4种滤波器
    switch i
        case 1,N = 1;
        case 2,N = 3;
        case 3,N = 5;
        case 4,N = 7;
    end
    Rs = 20;
    [z,p,k] = cheb2ap(N,Rs);        % 设计 Chebyshev II 型模拟原型滤波器
    [b,a] = zp2tf(z,p,k);           % 将零点极点增益形式转换为传递函数形式
    [H,w] = freqs(b,a,n);           % 按 n 指定的频率点给出频率响应
    magH2 = (abs(H)).^2;            % 给出传递函数幅度平方
    subplot(2,2,i);
    plot(w,magH2);
    title (['N=' num2str(N)]);
    xlabel('w/wc');
    ylabel('切比雪夫I型 |H(jw)|^2');
    grid on;
end
%}


% 设计切比雪夫II型模拟带通滤波器
%{
Wp = [3*pi*9000,3*pi*16000];
Ws = [3*pi*7000,3*pi*17000];
rp = 1;rs = 30;     % 模拟滤波器的设计指标
[N,wso] = cheb2ord(Wp,Ws,rp,rs,'s');    % 计算滤波器的阶数
[b,a] = cheby2(N,rs,wso,'s');           % 计算滤波器的系统函数的分子、分母向量
w =0:3*pi*100:3*pi*25000;
[h,w] = freqs(b,a,w);       % 计算频率响应
plot(w/(2*pi),20*log10(abs(h)),'k');
xlabel('f(Hz)');
ylabel('幅度(dB)');
grid on;
%}


% ellipord 函数设计椭圆滤波器
%{
Wp = 3*pi*4*12^3;
Ws = 2*pi*12*12^3;
rp = 2;
rs = 25;        % 设计滤波器的参数
wp = 1;
ws = Ws/Wp;     % 对参数归一化
[N,wc] = ellipord(wp,ws,rp,rs,'s');     % 计算滤波器阶数和阻带起始频率
[z,p,k] = ellipap(N,rp,rs);             % 计算零点、极点、增益
[B,A] = zp2tf(z,p,k);
w = 0:0.03*pi:2*pi;
[h,w] = freqs(B,A,w);
plot(w,20*log10(abs(h)),'k');
xlabel('\lambda');
ylabel('A(\lambda)/dB');
grid on;
%}


% ellipap 函数设计椭圆滤波器示例
%{
n = 0:0.02:4;
for i =1:4
    switch i
        case 1,N =1;
        case 2,N = 3;
        case 3,N = 5;
        case 4,N =7;
    end
    Rp =1;Rs = 15;          % 设置通滤波纹为 1dB，阻带衰减为15dB
    [z,p,k] = ellipap(N,Rp,Rs);     % 设计椭圆滤波器
    [b,a] = zp2tf(z,p,k);           % 将零点极点增益形式转换为传递函数形式
    [H,w] = freqs(b,a,n);           % 将n指定的频率点给出频率响应
    magH2 = (abs(H)).^2;            % 给出传递函数幅度平方
    subplot(2,2,i);
    plot(w,magH2);
    title(['N=' num2str(N)]);
    xlabel('w/wc');
    ylabel('|H(jw)|^2');
    grid on;
end
%}


% 设计合适的切比雪夫I型滤波器，实现低通到低通的频带变换
%{
Wp = 3*pi*5000;
Ws = 3*pi*13000;
rp = 2;
rs = 25;        % 模拟滤波器的设计指标
wp = Wp/Wp;ws = Ws/Wp;  
[N,wc] = cheb1ord(wp,ws,rp,rs,'s');    % 计算切比雪夫I型滤波器的阶数
[z,p,k] = cheb1ap(N,wc);        % 计算归一化滤波器的零、极点
[bp,ap] = zp2tf(z,p,k);         % 计算归一化滤波器的系统函数分子、分母系数
[b,a] = lp2lp(bp,ap,Wp);        % 计算一般模拟滤波器的系统函数分子、分母系数
w = 0:3*pi*120:3*pi*30000;
[h,w] = freqs(b,a,w);           % 计算频率响应
plot(w/(2*pi),20*log10(abs(h)),'k');
xlabel('f(Hz)');ylabel('幅度(dB)');grid on;
%}


% 4阶的椭圆滤波器低通到低通变换
%{
Rp = 3;Rs= 25;      % 模拟原型滤波器的通带波纹与阻带衰减
[z,p,k] = ellipap(4,Rp,Rs); % 设计椭圆滤波器
[b,a] = zp2tf(z,p,k);       % 由零点极点增益形式转换为传递函数形式 n=0
n =0:0.02:4;
[h,w] = freqs(b,a,n);       % 给出复数频率响应
subplot(121);plot(w,abs(h).^2);     % 给出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('原型低通椭圆滤波器(wc =1)');
grid on;
[bt,at] = lp2lp(b,a,0.5);       % 将模拟原型低通滤波器的截止频率变换为 0.5
[ht,wt] = freqs(bt,at,n);       % 给出复数频率响应
subplot(122);plot(wt,abs(ht).^2);   % 给出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('原型低通椭圆滤波器(wc =0.6)');
grid on;
%}

% 设计合适的切比雪夫I型滤波器，实现低通到高通的频带变换
%{
Wp = 3*pi*11000;
Ws = 3*pi*7000;
rp = 2;
rs = 25;        % 模拟滤波器的设计指标
wp = Wp/Wp;ws=Wp/Ws;    % 频带变换，得到归一化滤波器
[N,wc] = cheb1ord(wp,ws,rp,rs,'s'); % 计算切比雪夫I型滤波器的阶数
[z,p,k] = cheb1ap(N,wc);    % 计算归一化滤波器的零、极点
[bp,ap] = zp2tf(z,p,k); % 计算归一化滤波器的系统函数分子、分母系数
[b,a] =  lp2hp(bp,ap,Wp);       % 计算一般模拟滤波器的系统函数分子、分母系数
w = 0:3*pi*130:3*pi*25000;
[h,w] = freqs(b,a,w);           % 计算频率响应
plot(w/(2*pi),20*log10(abs(h)),'k');
grid on;
xlabel('f(Hz)');ylabel('幅度(dB)');
%}

% 将 5阶设计切比雪夫I 型模拟原型滤波器变换为截止频率为 0.6 的模拟高通滤波器
%{
Rp= 0.5;    % 设置滤波器的通带波纹为 0.5dB
[z,p,k] = cheb1ap(5,Rp);        % 设计切比雪夫I型模拟原型滤波器
[b,a] = zp2tf(z,p,k);       % 由零点极点增益形式转换为传递函数形式
n = 0:0.02:4;
[h,w] = freqs(b,a,n);       % 给出复数频率响应
subplot(121);
plot(w,abs(h).^2);  % 给出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('切比雪夫I型低通原型滤波器(wc=1)');
grid on;
[bt,at] = lp2hp(b,a,0.6);       % 由低通原型滤波器转换为截止频率为 0.8 的高通滤波器
[ht,wt] = freqs(bt,at,n);       % 给出复数频率响应
subplot(122);plot(wt,abs(ht).^2);       % 给出平方幅频函数
xlabel('w/wc');ylabel('椭圆|H(jw)|^2');
title('切比雪夫I型高通滤波器(wc=0.6)');
grid on;
%}

% 设计切比雪夫I型模拟带通滤波器，实现低通到带通的频带变换
%{
Wc1  = 3*pi*9000;
Wc2 = 3*pi*16000;
rp = 2;
rs = 25;
Wd1 = 3*pi*6000;
Wd2 = 3*pi*20000;       % 模拟滤波器的设计指标
B = Wc2-Wc1;
wo = sqrt(Wc1*Wc2);wp =1;
ws2 = (Wd2*Wd2-wo*wo)/Wd2/B;
ws1 = -(Wd1*Wd1 -wo*wo)/Wd1/B;
ws = min(ws1,ws2);      % 频带变换，得到归一化滤波器
[N,wc] = cheb1ord(wp,ws,rp,rs,'s');     % 计算切比雪夫I型滤波器的阶数
[z,p,k] = cheb1ap(N,wc);            % 计算归一化滤波器的零、极点
[bp,ap] = zp2tf(z,p,k);             % 计算归一化滤波器的系统函数分子、分母系数
[b,a] = lp2bp(bp,ap,wo,B);          % 计算一般模拟滤波器的系统函数分子、分母系数
w =0:3*pi*130:3*pi*25000;
[h,w] = freqs(b,a,w);
plot(w/(2*pi),20*log10(abs(h)),'k');
axis([0,30000,-100,0]);
xlabel('f(Hz)');
ylabel('幅度(dB)');
grid on;
%}

% 将4阶切比雪夫II 型模拟原型滤波器变换为模拟带通滤波器
%{
Rs = 30;    %滤波器的阻带衰减为 20dB
[z,p,k] = cheb2ap(4,Rs);    % 设计切比雪夫II型模拟原型滤波器
[b,a] = zp2tf(z,p,k);       % 由零点极点增益形式转换为传递函数形式
n = 0:0.02:4;
[h,w] = freqs(b,a,n);       % 给出复数频率响应
subplot(121);plot(w,abs(h).^2);     % 绘出平方幅频函数
xlabel('w/wc');ylabel('切比雪夫II 型|H(jw)|^2');
title('切比雪夫II型低通原型滤波器(wc=1)');
grid on;
w1 = 0.7;w2 =1.6;       % 给定将要设计滤波器通带的下限和上限频率
w0 = sqrt(w1*w2);       % 计算中心点频率
bw = w2-w1;             % 计算中心点频带宽度
[bt,at] = lp2bp(b,a,w0,bw);     % 频率转换
[ht,wt] = freqs(bt,at,n);   % 计算滤波器的复数频率响应
subplot(122);plot(wt,abs(ht).^2);       % 给出平方幅频函数
xlabel('w/wc');ylabel('切比雪夫II型|H(jw)|^2');
title('切比雪夫II型带通滤波器(wc=0.7~1.6)');
grid on;
%}


% 设计合适的切比雪夫I型滤波器，实现低通到带阻的频带变换
%{
Wc1  = 3*pi*9000;
Wc2 =  3*pi*16000;
rp = 2;
rs = 25;
Wd1 = 3*pi*6000;
Wd2 = 3*pi*20000;       % 模拟滤波器的设计指标
B = Wd2-Wd1;
wo = sqrt(Wd1*Wd2);wp =1;
ws2 = (Wc2*B)/(Wc2*Wc2-wo*wo);
ws1 = -(Wc1*B)/(Wc1*Wc1-wo*wo);
ws = min(ws1,ws2);      % 频带变换，得到归一化滤波器
[N,wc] = cheb1ord(wp,ws,rp,rs,'s');     % 计算切比雪夫I型滤波器的阶数
[z,p,k] = cheb1ap(N,wc);            % 计算归一化滤波器的零、极点
[bp,ap] = zp2tf(z,p,k);             % 计算归一化滤波器的系统函数分子、分母系数
[b,a] = lp2bs(bp,ap,wo,B);          % 计算一般模拟滤波器的系统函数分子、分母系数
w =0:3*pi*130:3*pi*25000;
[h,w] = freqs(b,a,w);
plot(w/(2*pi),20*log10(abs(h)),'k');
axis([0,30000,-100,0]);
xlabel('f(Hz)');
ylabel('幅度(dB)');
grid on;
%}


% 将5阶巴特沃斯模拟原型滤波器变换为模拟带阻滤波器，上下边界频率为 wc =0.6~1.6rad/s
%{
[z,p,k] = buttap(5);    % 设计巴特沃斯模拟原型滤波器
[b,a] = zp2tf(z,p,k);       % 由零点极点增益形式转换为传递函数形式
n = 0:0.02:4;
[h,w] = freqs(b,a,n);       % 给出复数频率响应
subplot(121);plot(w,abs(h).^2);     % 绘出平方幅频函数
xlabel('w/wc');ylabel('巴特沃斯|H(jw)|^2');
title('wc=1');
grid on;
w1 = 0.6;w2 =1.6;       % 给定将要设计带阻下限和上限频率
w0 = sqrt(w1*w2);       % 计算中心点频率
bw = w2-w1;             % 计算中心点频带宽度
[bt,at] = lp2bs(b,a,w0,bw);     % 频率转换
[ht,wt] = freqs(bt,at,n);   % 计算滤波器的复数频率响应
subplot(122);plot(wt,abs(ht).^2);       % 给出平方幅频函数
xlabel('w/wc');ylabel('巴特沃斯|H(jw)|^2');
title('wc=0.6~1.6');
grid on;
%}


% 通过冲激响应不变法设计巴特沃斯数字滤波器
%{
T = 2;      % 设置采样周期为2
fs = 1/T;   % 采样频率为周期倒数
Wp = 0.30 *pi/T;
Ws = 0.35*pi/T;     % 设置归一化通带和阻带截止频率
Ap = 20*log10(1/0.8);
As = 20*log10(1/0.18);  % 设置通带最大和最小衰减
[N,Wc] = buttord(Wp,Ws,Ap,As,'s');
% 调用 butter 函数确定巴特沃斯滤波器阶数
[B,A] = butter(N,Wc,'s');
% 调用butter 函数设计巴特沃斯滤波器
W = linspace(0,pi,400*pi);      % 指定一段频率值
hf = freqs(B,A,W);
% 计算模拟滤波器的幅频响应
subplot(121);
plot(W/pi,abs(hf)/abs(hf(1)));
% 绘出巴特沃斯模拟滤波器的幅频特性曲线
grid on;
title('巴特沃斯模拟滤波器');
xlabel('Frequency/Hz');
ylabel('Magnitude');
[D,C] = impinvar(B,A,fs);
% 调用冲激响应不变法
Hz = freqz(D,C,W);
% 返回频率响应
subplot(122);
plot(W/pi,abs(Hz)/abs(Hz(1)));
% 绘出巴特沃斯数字低通滤波器的幅频特性曲线
grid on;
title('巴特沃斯数字滤波器');
xlable('Frequency/Hz');
ylabel('Magnitude');
%}

% 用冲激响应不变法设计椭圆数字滤波器
%{
wp = 400*pi*2;
ws = 420*2*pi;
rs = 90;
rp = 0.25;
fs = 1450;
[n,wn] = ellipord(wp,ws,rp,rs,'s');
[z,p,k] = ellipap(n,rp,rs);
[a,b,c,d] = zp2ss(z,p,k);
[at,bt,ct,dt] = lp2lp(a,b,c,d,wn);
[num1,den1] = ss2tf(at,bt,ct,dt);
[num2,den2] = impinvar(num1,den1,fs);
[h,w] = freqz(num2,den2);
figure;
winrect = [150,150,450,350];
set(gcf,'position',winrect);
set(gco,'linewidth',1);
freqz(num2,den2);
xlabel('归一化角频率');ylabel('相角');
figure;
winrect= [150,150,450,350];
set(gcf,'position',winrect);
plot(w*fs/(2*pi),abs(h));
grid on;
xlabel('频率(Hz)');ylabel('幅值');
%}

% 利用巴特沃斯模拟滤波器，通过双线性变换法设计数字带阻滤波器
%{
T = 1;      % 设置采样周期为 1
fs = 1/T;       % 采样频率为周期倒数
wp = [0.30 *pi,0.75*pi];
ws = [0.35*pi,0.65*pi];
Wp = (2/T) *tan(wp/2);
Ws = (2/T) * tan(ws/2);     % 设置归一化通带和阻带截止频率
Ap = 20*log10(1/0.8);
As = 20*log10(1/0.18);
% 设置通带最大和最小衰减
[N,Wc] = buttord(Wp,Ws,Ap,As,'s');
% 调用 butter 函数确定巴特沃斯滤波器阶数
[B,A] = butter(N,Wc,'stop','s');
% 调用 butter 函数设计巴特沃斯滤波器
W = linspace(0,2*pi,400*pi);
% 指定一段频率值
hf = freqs(B,A,W);
% 计算模拟滤波器的幅频响应
subplot(121);
plot(W/pi,abs(hf));
% 绘出巴特沃斯模拟滤波器的幅频特性曲线
grid on;
title('巴特沃斯模拟滤波器');
xlabel('Frequency/Hz');
ylabel('Magnitude');
[D,C] = bilinear(B,A,fs);
% 调用双线性变换法
Hz = freqz(D,C,W);
% 返回频率响应
subplot(122);
plot(W/pi,abs(Hz));
% 绘出巴特沃斯数字带阻滤波器的幅频特性曲线
grid on;
title('巴特沃斯数字滤波器');
xlabel('Frequency/Hz');
ylabel('Magnitude');
%}

% 用双线性变换法设计椭圆数字滤波器
%{
wp = 400*2*pi;
ws = 420*2*pi;
rs = 90;rp =0.25;fs = 1450;
[n,wn] = ellipord(wp,ws,rp,rs,'s');
[z,p,k] = ellipap(n,rp,rs);
[a,b,c,d] = zp2ss(z,p,k);
[at,bt,ct,dt] = lp2lp(a,b,c,d,wn);
[num1,den1] = ss2tf(at,bt,ct,dt);
[num2,den2] = bilinear(num1,den1,fs);
[h,w] = freqz(num2,den2);
figure;
winrect = [100,100,400,300];
set(gcf,'position',winrect);
set(gco,'linewidth',1);
freqz(num2,den2);
xlabel('归一化角频率');
ylabel('相角');
figure;
winrect = [100,100,400,300];
set(gcf,'position',winrect);
plot(w*fs/(2*pi),abs(h));
grid on;
xlabel('频率(Hz)');ylabel('幅值');
%}

% 用buttord 函数选择合适的阶数,巴特沃斯幅频响应
%{
Fs = 40000;fp = 5000;fs = 9000;
rp = 1;rs = 30;
wp = 2*fp/Fs;ws = 2*fs/Fs;  % 计算数字滤波器的设计指标
[N,wc] = buttord(wp,ws,rp,rs);  % 计算数字滤波器的阶数和通带截止频率
[b,a] = butter(N,wc);           % 计算数字滤波器系统函数
w = 0:0.01*pi:pi;
[h,w] = freqz(b,a,w);       % 计算数字滤波器的幅频响应
plot(w/pi,20*log10(abs(h)),'k');
axis([0,1,-100,10]);
xlabel('\omega/\pi');ylabel('幅度(dB)');grid on;

% cheb1ord 函数用法示例，切比雪夫I型滤波器频率响应
Wp = [60 200]/500;
Ws = [50 250]/500;
Rp = 3;
Rs = 40;
[n,Wn] = cheb1ord(Wp,Ws,Rp,Rs);
[b,a] = butter(n,Wn);
freqz(b,a,128,1000);
title('n=? 巴特沃斯滤波器');
%}


% 绘制模拟滤波器的传递函数示例
%{
a = [1 0.5 2];      % 滤波器传递函数分母多项式系数
b = [0.4 0.5 2];    % 滤波器传递函数分子多项式系数
w = logspace(-1,1);
freqs(b,a,w);
h = freqs(b,a,w);
mag = abs(h);
phase = angle(h);
subplot(2,2,1);loglog(w,mag);       % 运用双对数坐标绘制幅频响应
grid on;
xlabel('角频率');ylabel('振幅');
subplot(2,1,2);semilogx(w,phase);   % 运用半对数坐标绘制相频响应
grid on;
xlabel('角频率');
ylabel('相位');
%}

% 滤波器的输出及其输入、输出信号的傅里叶振幅谱
%{
dt = 1/2000;
t = 0:dt:0.1;       % 给出模拟滤波器输出的时间范围
% 模拟输入信号
u = tan(2*pi*30*t) + 0.5*sin(2*pi*300*t) +2*cos(2*pi*800*t);
subplot(2,2,1);plot(t,u);   % 绘制模拟输入信号
xlabel('时间/s');title('输入信号');
%[ys,ts] = lsim(u,t);      % 模拟系统的输入u 时的输出
subplot(2,2,2);
%plot(ts,ys);     % 绘制模拟输入信号
xlabel('时间/s');title('输出信号');
% 绘制输入信号振幅谱
subplot(2,2,3);plot((0:length(u)-1)/length(u)*dt,abs(fft(u))* 2/length(u));
xlabel('频率/Hz');title('输入信号振幅谱');
subplot(2,2,4);
Y = fft(ys);
% 绘制输出信号振幅谱
plot((0:length(Y)-1)/(length(Y)*dt),abs(Y)*2/length(Y));
xlabel('频率/Hz');
title('输出信号振幅谱');
%}

% 设计一个 6 阶的切比雪夫II型带通滤波器   ??? tf 函数不能使用
%{
N= 6;
Rp =3;      % 滤波器的阶数
f1 = 150;
f2 = 600;
w1 = 2*pi*f1;
w2 = 2*pi*f2;       % 边界频率(rad/s)
[z,p,k] = cheb2ap(N,Rp);        % 设计切比雪夫II型原型低通滤波器
[b,a] = zp2tf(z,p,k);           % 转换为传递函数形式
Wo = sqrt(w1*w2);               % 中心频率
Bw = w2-w1;                     % 频带宽度
[bt,at] = lp2bp(b,a,Wo,Bw);     % 频率转换
[h,w] = freqs(bt,at);
figure;
subplot(2,2,1);
semilogy(w/2/pi,abs(h));        % 绘制幅频特性
xlabel('频率/Hz');title('幅频图');
grid on;
subplot(2,2,2);plot(w/2/pi,angle(h)*180/pi);        % 绘制相频响应
xlabel('频率/Hz');ylabel('相位图/^o');title('相频图');
grid on;
H = [tf(bt,at)];        % 在MATLAB 中表示此滤波器
[h1,t1]= impulse(H);        % 绘出系统的冲激响应图
subplot(2,2,3);plot(t1,h1);
xlabel('时间/s');title('脉冲冲激响应');
[h1,h2] = step(H);      % 给出系统的阶跃响应
subplot(2,2,4);plot(t2,h2);
xlabel('时间/s');title('阶跃响应');
%}

% 设计一个 三阶巴特沃斯LP 滤波器，分别用冲激响应不变法和双线性变换法
%{
[B,A] = butter(3,2*pi*1000,'s');
[num1,den1] = impinvar(B,A,4000);       % 冲激响应不变法
[h1,w] = freqz(num1,den1);
[B,A] = butter(3,2/0.00025,'s');
[num2,den2] = bilinear(B,A,4000);       % 双线性变换
[h2,w] = freqz(num2,den2);
f = w/pi*2000;
plot(f,abs(h1),'-.',f,abs(h2),'-');
grid on;
xlabel('频率/Hz');
ylabel('幅值');
%}


% 设计一个巴特沃斯带通滤波器，90k-120kHz，阻带 120kHz 处最小衰减大于 10dB
%{
w1 = 2*500*tan(2*pi*90/(2*400));
w2 = 2*500*tan(2*pi*110/(2*400));
wr = 2*500*tan(2*pi*120/(2*400));
[N,wn] = buttord([w1,w2],[1 wr],3,10,'s');
[B,A] = butter(N,wn,'s');
[num,den] = bilinear(B,A,400);
[h,w] = freqz(num,den);
f = w/pi*200;
plot(f,20*log10(abs(h)));
axis([40,160,-30,10]);
grid on;
xlabel('频率/Hz');ylabel('幅度/dB');
%}

% 采样率 1kHz，要求滤除100Hz 的干扰，其 3dB 的边界频率为 85Hz 和 125Hz,原型归一化低通滤波器
%{
w1 = 85/500;
w2 = 125/500;
[B,A] = butter(1,[w1,w2],'stop');
[h,w] = freqz(B,A);
f = w/pi*500;
plot(f,20*log10(abs(h)));
axis([50,150,-30,10]);
grid on;
xlabel('频率/Hz');
ylabel('幅度/dB');
%}

% 用冲激响应不变法设计一个巴特沃斯低通滤波器，使其特征逼近一个低通巴特沃斯模拟滤波器的性能指标
%{
wp = 2000 * 2*pi;
ws = 3000*2*pi;     % 滤波器截止频率
Rp = 3;
Rs = 15;            % 通带波纹和阻带衰减
Fs = 9000;          % 采样频率
Nn = 256;           % 调用 freqz 所用的频率点数
[N,wn] = buttord(wp,ws,Rp,Rs,'s');  % 模拟滤波器的最小阶数
[z,p,k] = buttap(N);            % 设计模拟低通原型巴特沃斯滤波器
[Bap,Aap] = zp2tf(z,p,k);       % 将零点极点增益形式转换为传递函数形式
[b,a] = lp2lp(Bap,Aap,wn);      % 进行频率转换
[bz,az] = impinvar(b,a,Fs);
% 运用冲激响应不变法得到数字滤波器的传递函数
figure;
[h,f] = freqz(bz,az,Nn,Fs);     % 绘制数字滤波器的幅频特性和相频特性
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
f1 = 1000;f2 = 2000;        % 输入信号的频率
N = 100;                    % 数据长度
dt = 1/Fs; n = 0:N-1;       % 采样时间间隔
t = n*dt;               % 时间序列
x = tan(2*pi*f1*t) +0.5*sin(2*pi*f2*t);    % 滤波器输入信号
subplot(223);
plot(t,x);
title('输入信号');       % 绘制输入信号
y = filtfilt(bz,az,x);       % 用函数 filtfilt 对输入信号进行滤波
y1 = filter(bz,az,x);       % 用 filter 函数对输入信号进行滤波
subplot(224);plot(t,y,t,y1,':');
title('输出信号');
xlabel('时间/s');
legend('filtfilt 函数','filter函数');
%}


% 用双线性变换法设计一个椭圆低通滤波器
%{
wp = 0.3*pi;
ws = 0.4*pi;        % 对数字滤波器截止频率通带波纹
Rp = 2;
Rs = 30;            % 阻带衰减
Fs = 100;
Ts = 1/Fs;          % 采样频率
Nn = 256;           % 采用 freqz 所用的频率点数
wp = 2/Ts*cos(wp/2);
ws = 2/Ts*cos(ws/2);        % 按频率公式进行转换
[n,wn]  = ellipord(wp,ws,Rp,Rs,'s');        % 计算模拟滤波器的最小阶数
[z,p,k] = ellipap(n,Rp,Rs);     % 设计模拟原型滤波器
[Bap,Aap] = zp2tf(z,p,k);       % 零点极点增益形式转换为传递函数形式
[b,a] = lp2lp(Bap,Aap,wn);      % 低通转换为低通滤波器的频率转换
[bz,az] = bilinear(b,a,Fs);     % 运用双线性变换法得到数字滤波器传递函数
[h,f] = freqz(bz,az,Nn,Fs);     % 绘出频率特性
subplot(121);plot(f,20*log10(abs(h)));
xlabel('频率/Hz');ylabel('振幅/dB');
grid on;
subplot(122);plot(f,180/pi*unwrap(angle(h)));
xlabel('频率/Hz');ylabel('相位/^o');
grid on;
%}

% 设计一个数字高通滤波器，通带为 400-500Hz，通带内容许有 0.5dB 的波动，阻带内衰减在小于 317Hz的频带内至少为 19dB
% ，采样频率为1000Hz
wc = 2*1000*tan(2*pi*400/(2*1000));
wt = 2*1000*tan(2*pi*317/(2*1000));
[N,wn] = cheb1ord(wc,wt,0.5,19,'s');
% 选择最小阶和截止频率
% 设计高通滤波器
[B,A] = cheby1(N,0.5,wn,'high','s');
% 设计切比雪夫I型模拟滤波器
[num,den] = bilinear(B,A,1000);
% 数字滤波器设计
[h,w] = freqz(num,den);
f = w/pi*500;
plot(f,20*log10(abs(h)));
axis([0,500,-80,10]);
grid on;
xlabel('频率/Hz');
ylabel('幅度/dB');









