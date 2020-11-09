% 其他滤波器
% 维纳滤波器、卡尔曼滤波器、自适应滤波器、格型滤波器

clear all;
close all;
clc;

% 维纳滤波器示例
L = input('请输入信号长度L=');      % L = 500
N = input('请输入滤波器阶数 N=');   % N = 100
% 产生 w(n),v(n),u(n),s(n) 和 x(n)
a = 0.95;
b1 = sqrt(12*(1-a^2))/2;
b2 = sqrt(3);
w = random('uniform',-b1,b1,1,L);   % 利用 random 函数产生均匀白噪声
v = random('uniform',-b2,b2,1,L);
u = zeros(1,L);
for i =1:L
    u(i) = 1;
end
s = zeros(1,L);
s(1) = w(1);
for i =2:L
    s(i) = a*s(i-1)+w(i);
end
x = zeros(1,L);
x = s+v;
% 绘出 s(n) 和 x(n)的曲线图
set(gca,'Color',[1,1,1]);
i = L-100:L;
subplot(2,2,1);
plot(i,s(i),i,x(i),'r:');
title('s(n) & x(n)');
legend('s(n)','x(n)');
% 计算理想滤波器的 h(n)
h1 = zeros(N:1);
for i=1:N
    h1(i) = 0.238*0.724^(i-1)*u(i);
end
% 利用公式，计算 Rxx 和 rxs
Rxx = zeros(N,N);
rxs = zeros(N,1);
for i=1:N
    for j=1:N
        m = abs(i-j);
        tmp =0;
        for k=1:(L-m)
            tmp = tmp+x(k)*x(k+m);
        end
        Rxx(i,j) = tmp/(L-m);
    end
end
for m=0:N-1
    tmp = 0;
    for i=1:L-m
        tmp = tmp+x(i)*s(m+i);
    end
    rxs(m+1) = tmp/(L-m);
end
% 产生 FIR 维纳滤波器的 h(n)
h2 = zeros(N,1);
h2 = Rxx^(-1)*rxs;
% 绘出理想和维纳滤波器 h(n) 的曲线图
i =1:N;
subplot(2,2,2);
plot(i,h1(i),i,h2(i),'r:');
title('h(n) & h~(n)');
legend('h(n)','h~(n)');
% 计算 Si
Si = zeros(1,L);
Si(1) = x(1);
for i=2:L
    Si(i) = 0.724*Si(i-1) +0.238*x(i);
end
% 绘出 Si(n) 和 s(n) 曲线图
i = L-100:L;
subplot(2,2,3);
plot(i,s(i),i,Si(i),'r:');
title('Si(n) & s(n)');
legend('Si(n)','s(n)');
% 计算 Sr
Sr = zeros(1,L);
for i=1:L
    tmp = 0;
    for j=1:N-1
        if(i-j <=0)
            tmp = tmp;
        else
            tmp = tmp+h2(j)*x(i-j);
        end
    end
    Sr(i) = tmp;
end
% 绘出 Si(n) 和s(n) 曲线图
i = L-100:L;
subplot(2,2,4);
plot(i,s(i),i,Sr(i),'r:');
title('s(n)','Sr(n)');
% 计算均方误差 Ex,Ei和Er
tmp = 0;
for i=1:L
    tmp = tmp +(x(i) - s(i))^2;
end
Ex = tmp/L;     % 打印出 Ex
tmp = 0;
for i =1:L
    tmp = tmp+(Si(i) - s(i))^2;
end
Ei = tmp/L;
tmp =0;
for i= 1:L
    tmp = tmp + (Sr(i)-s(i))^2;
end
Kr = tmp/L;





% 卡尔曼滤波器示例
% 对变量进行赋值语句： kalman1(100,0.85,1,0,1,1,0,0.0875,0.1)
function kalman1(L,Ak,Ck,Bk,Wk,Vk,Rw,Rv)
w = sqrt(Rw) *randn(1,L);       % w 为均值零方差为 Rw 高斯白噪声
v = sqrt(Rv) *randn(1,L);       % v 为均值零方差为 Rv 高斯白噪声
x0 = sqrt(10^(-12))*randn(1,L);
for i=1:L
    u(i) = 1;
end
x(1) = w(1);        % 给 x(1) 赋初值
for i=2:L           % 递归求出 x(k)
    x(i)= Ak *x(i-1)+Bk*u(i-1)+Wk*w(i-1);
end
yk = Ck *x +Vk*v;
yik = Ck *x;
n =1:L;
subplot(2,2,1);
plot(n,yk,n,yik,'r:');
legend('yk','yik',1);
Qk = Wk*Wk'*Rw;
Rk = Vk*Vk'*Rv;
P(1) = var(x0);
% P(1) = 10;
% P(1) = 10^(-12);
P1(1) = Ak*P(1)*Ak'+Qk;
xg(1) =0;
for k=2:L
    P1(k) = Ak*P(k-1)*Ak'+Qk;
    H(k) = P1(k)*Ck'*inv(Ck*P1(k)*Ck'+Rk);
    I = eye(size(H(k)));
    P(k) = (I-H(k)*Ck)*P1(k);
    xg(k) = Ak*xg(k-1)+H(k)*(yk(k)-Ck*Ak*xg(k-1))+Bk*u(k-1);
    yg(k) = Ck*xg(k);
end
subplot(2,2,2);
plot(n,P(n),n,H(n),'r:');
legend('P(n)','H(n)',4);
subplot(2,2,3);
plot(n,x(n),n,xg(n),'r:');
legend('x(n)','估计xg(n)',1);
subplot(2,2,4);
plot(n,yik(n),n,yg(n),'r:');
legend('估计yg(n)','yik(n)',1);
set(gcf,'Color',[1,1,1]);


% 2阶加权自适应滤波器
t = 0:1/10000:1-0.0001; 
s = cos(2*pi*t) +sin(2*pi*t);   % 输入信号
n = randn(size(t));             % 产生随机噪声
x = s+n;
w = [0 0.5];
u = 0.00026;
for i=1:9999
    y(i+1) = n(i:i+1) *w';
    e(i+1) = x(i+1) -y(i+1);
    w = w+2*u*e(i+1) *n(i:i+1);
end
figure;
subplot(3,1,1),plot(t,x);
title('带噪声输入信号');
subplot(3,1,2);plot(t,s);
title('输入信号');
subplot(3,1,3);
plot(t,e);
title('滤波结果');


% FIR 滤波器的自适应调整
ee = 0;
fs = 800;      % 采样频率 800Hz
det = 1/fs;
f1 = 100;f2=200;
t = 0:det:2-det;
x = sin(2*pi*f1*t) +cos(2*pi*f2*t) +randn(size(t));
% 未知系统
[b,a] = butter(5,150*2/fs);     % 截止频率取 150Hz
d = filter(b,a,x);              % 自适应FIR滤波器
N = 5;
delta = 0.06;
M = length(x);
y = zeros(1,M);
h = zeros(1,N);
for n =N:M
    x1 = x(n:-1:n-N+1);
    y(n) = h *x1';
    e(n) = d(n) -y(n);
    h = h+delta.*e(n).*x1;
end
x = abs(fft(x,2048));
Nx = length(x);
kx = 0:800/Nx:(Nx/2-1)*(800/Nx);
p = abs(fft(d,2048));
Nd = length(D);
kd = 0:800/Nd:(Nd/2-1) *(800/Nd);
y = abs(fft(y,2048));
Ny = length(y);
ky = 0:800/Ny:(Ny/2-1)*(800/Nd);
figure;
subplot(131);plot(kx,x(1:Nx/2));
xlabel('Hz');
title('原始信号频谱');
subplot(132);plot(kd,D(1:Nd/2));
title('经未知系统后');xlabel('Hz');
subplot(133);plot(ky,y(1:Ny/2));
title('经自适应FIR滤波器后');xlabel('Hz');



% 调用tf2latc 求出 Lattice 结构
X = tf2latc(b/b(1));
clear all;
close all;
clc;
b = [3 12/11 6/5 3/4];
K = tf2latc(b/b(1));
x = [1 ones(1,31)];
h1 = filter(b/b(1),1,x);
h2 = latcfilt(K,x);
subplot(121);
stem(0:31,h1,'LineWidth',2);xlabel('n');
ylabel('h1(n)');title('直接型结构的冲激响应');
axis([-1 33 -0.2 3]);
subplot(122);
stem(0:31,h2,'LineWidth',2);xlabel('n');
ylabel('h2(n)');title('Lattice 结构的冲激响应');
axis([-1 33 -0.2 3]);
set(gca,'color','w');


% 调用 tf2latc 求出它的全极点 Lattice 结构
a = [1 14/26 6/11 1/3];
K = tf2latc(a/a(1))


% 
b = [0.0202 0 -0.0403 0 0.0205];
a = [1 -1.647 2.247 -1.407 0.64];
[K,C] = tf2latc(b,a);
x = sin(0.1 * pi*(0:79))+sin(0.35 *pi*(0:79));
y1 = filter(b,a,x);
y2 = latcfilt(K,C,x);
subplot(311);
plot(0:79,x);xlabel('n');ylabel('x(n)');grid on;
title('输入信号');
axis([-1 81 -2.2 2.2]);
subplot(312);
plot(0:79,y1);xlabel('n');ylabel('y1(n)');grid on;
title('直接型结构的输出');axis([-1 81 -1.2 1.2]);
subplot(313);
plot(0:79,y2);xlabel('n');ylabel('y2(n)');grid on;
title('零极点系统的 Lattice 结构的输出');axis([-1 81 -1.2 1.2]);
set(gcf,'color','w');



% 自相关法求AR模型谱估计
N = 256;
% 信号长度
f1 = 0.025;
f2 = 0.2;
f3 = 0.21;
A1  = -0.750737;
p =15;
% AR 模型阶次
V1 = randn(1,N);
V2 = randn(1,N);
U =0;
% 噪声均值
Q = 0.101043;
% 噪声方差
b = sqrt(Q/2);
V1 = U +b*V1;
% 生成1*N 阶均值为U ，方差为Q/2的高斯白噪声序列
V2 = U+b*V2;
% 生成1*N 阶均值为U,方差为 Q/2 的高斯白噪声序列
V = V1+j*V2;    % 生成1*N阶均值为 U,方差为 Q 的复高斯白噪声序列
z(1) = V(1,1);
for n =2:1:N
    z(n) = -A1*z(n-1)+V(1,n);
end
x(1) = 6;
for n=2:1:N
    x(n) = 2*cos(2*pi*f1*(n-1)) +2*cos(2*pi*f2*(n-1))+2*cos(2*pi*f3*(n-1))+z(n-1);
end
for k=0:1:p
    t5 =0;
    for n =0:1:N-k-1
        t5 = t5 + conj(x(n+1))*x(n+1+k);
    end
    Rxx(k+1) = t5/N;
end
a(1,1) = -Rxx(2)/Rxx(1);
p1(1) = (1-abs(a(1,1))^2)*Rxx(1);
for k = 2:1:p
    t=0;
    for l = 1:1:k-1
        t = a(k-1,l).*Rxx(k-l+1)+t;
    end
    a(k,k) = -(Rxx(k+1)+t)./pi(k-1);
    for i=1:1:k-1
        a(k,i) = a(k-1,i)+a(k,k)*conj(a(k-1,k-i));
    end
    p1(k) = (1-(abs(a(k,k)))^2).*p1(k-1);
end
for k=1:1:p
    a(k) = a(p,k)
end
f = -0.5:0.0001:0.5;
f0 = length(f);
for t = 1:f0
    s = 0;
    for k = 1:p
        s = s+a(k)*exp(-j*2*pi*f(t)*k);
    end
    x(t) = Q/(abs(1+s))^2;
end
plot(f,10*log10(x));
xlabel('频率');
ylabel('PSD(dB)');
title('自相关法求AR模型谱估计');


% 利用预测器来估计模型系数，并与最初的信号相比较
randn('state',0);
noise = randn(40000,1);     % 正态高斯白噪声
x = filter(1,[1 1/2 1/3 1/4],noise);
x = x(35904:40000);
% 调用线性预测函数 lpc,计算预测系数，并估算预测误差以及预测误差的自相关
a = lpc(x,3);
est_x = filter([0 -a(2:end)],1,x);      % 信号估算
e = x- est_x;               % 预测误差
[acs,lags] = xcorr(e,'coeff');      % 预测误差的ACS
% 比较预测信号和原始信号
subplot(211);
plot(1:97,x(3001:3097),1:97,est_x(3001:3097),'--');
title('比较预测信号和原始信号');
xlabel('Sample Number');ylabel('Amplitude');
grid on;
% 分析预测误差的自相关
subplot(212);
plot(lags,acs);
title('分析预测误差的自相关');
xlabel('Lags');
ylabel('Normalized Value');
grid on;



% 建立一个AR模型，利用相应的仿真算法进行时域模型的参数估计以及仿真随机信号的频域分析
% 仿真信号功率谱估计和自相关函数
a = [2 0.3 0.2 0.5 0.2 0.4 0.6 0.2 0.2 0.5 0.3 0.2 0.6];
% 仿真信号
t =0:0.001:0.4;
y = sin(2*pi*t*30) +cos(0.35*pi*t*30)+randn(size(t));
% 加入白噪声正弦信号
x = filter(1,a,y);
% 周期图估计，512点FFT
subplot(221);
periodogram(x,[],512,1000);
axis([0 500 -50 0]);
xlabel('频率/Hz');
ylabel('功率谱/dB');
title('周期图功率谱估计');
grid on;
% welch 功率谱估计
subplot(222);
pwelch(x,128,64,[],1000);
axis([0 500 -50 0]);
xlabel('频率/Hz');
ylabel('功率谱/dB');
title('welch功率谱估计');
grid on;
subplot(212);
R = xcorr(x);
plot(R);
axis([0 600 -500 500]);
xlabel('时间/t');
ylabel('R(t)/dB');
title('x 的自相关函数');
grid on;


% MA 模型功率谱估计实现
N = 456;
B1 = [1 0.2544 0.2509 0.1826 0.2401];
A1 = [4];
w = linspace(0,pi,512);
H1 = freqz(B1,A1,w);
% 产生信号的频域响应
Ps1 = abs(H1).^2;       
SPy11 = 0;          % 20次 AR(4)
SPy14 =0;           % 20次 MA(4)    
VSPy11 = 0;         % 20次 AR(4)
VSPy14 =0;          % 20次 MA(4)
for k = 1:20
    % 采用自协方差法对 AR模型参数进行估计
    y1 = filter(B1,A1,randn(1,N)).*[zeros(1,200),ones(1,256)];
    [Py11,F] = pcov(y1,4,512,1);            % AR(4) 的估计
    [Py13,F] = periodogram(y1,[],512,1);
    SPy11 = SPy11 +Py11;
    VSPy11 = VSPy11 +abs(Py11).^2;
    y = zeros(1,256);
    for i=1:256;
        y(i) = y1(200+i);
    end
    ny = [0:255];
    z = fliplr(y);nz = -fliplr(ny);
    nb = ny(1)+nz(1);ne = ny(length(y))+nz(length(z));
    n = [nb:ne];
    Ry = conv(y,z);
    R4 = zeros(8,4);
    r4 = zeros(8,1);
    for i=1:8
        r4(i,1) = -Ry(260+i);
    end
end
R4 
r4
a4 = inv(R4'*R4)*R4'*r4;
% 利用最小二乘法得到的估计参数
% 对MA 的参数b(1)-b(4) 进行估计
A1
A14 = [1,a4'];
% AR 的参数 a(1)-a(4) 的估计值
B14 = fliplr(conv(fliplr(B1),fliplr(A14)));
% MA 模型的分子 '
y24 = filter(B14,A1,randn(1,N));    % .*[zeros(1,200)]
% 由估计出的 MA 模型产生数据
[Ama4,Ema4] = arburg(y24,32);
B1
b4 = arburg(Ama4,4);
% 求出 MA 模型的参数
% ------ 求功率谱 -----
w = linspace(0,pi,512);
% H1 = freqz(B1,A1,w);
H14 = freqz(b4,A14,w);
% 产生信号的频域响应
% Ps1 = abs(H1).^2;         % 真实谱
Py14 = abs(H14).^2;         % 估计谱  
SPy14 = SPy14+Py14;
VSPy14 = VSPy14 +abs(Py14).^2;
end
figure(1);
plot(w./(2*pi),Ps1,w./(2*pi),SPy14/20);
legend('真实功率谱','20次MA(4)估计的平均值');
grid on;
xlabel('频率');
ylabel('功率');


% 模拟一个 ARMA 模型，然后进行时频归并，考察归并前后模型的变化
tic
% s 设定 ARMA 模型的多项式系数，ARMA 模型中只有多项式 A(q) 和C(q)
a1 = -(0.6)^(1/3);
a2 = (0.6)^(2/3);
a3 = 0;
a4 = 0;
c1 = 0;
c2 = 0;
c3 = 0;
c4 = 0;
obv = 3000;
% obv 是模拟的观测数目
A = [1 a1 a2 a3 a4];
B = [];
% 因为ARMA 模型没有输入，因此多项式B 是空的
C = [1 c1 c2 c3 c4];
D = [];
% 把 D也设为空的
F =[];
% ARMA 模型里的 F 多项式也是空的
e = idpoly(A,B,C,D,F,1,1);
% 这样就生成了ARMA 模型，把它存储在 m 中，抽样间隔Ts 设为1
error = randn(obv,1);
% 生成一个 obv*1 的正态随机序列，准备用作模型的误差项
e = iddata([],error,1);
% 用 randn 函数生成一个噪声序列，存储在 e 中，抽样间隔是1秒
% u =[];
% 因为是 ARMA 模型，没有输出，所以把 u 设为空的
y = sim(m,e);
get(y);
% 使用 get 函数来查看动态系统的所有性质
r = y.OutputData;
% 把 y.OutputData 的全部值赋给变量 r,r就是一个 obv *1 的向量
figure(1);
plot(r);
title('模拟信号');
ylabel('幅值');
xlabel('时间');
% 绘出 y 随时间变化的曲线
figure(2);
subplot(2,1,1);
n = 100;
[ACF,Lags,Bounds] = autocorr(r,n,2);
x - Lags(2:n);
y = ACF(2:n);
% 注意这里的y 和前面 y 的完全不同
h = stem(x,y,'fill','-');
set(h(1),'Marker','.');
hold on;
ylim([-1 1]);
a = Bounds(1,1) *ones(1,n-1);
line('XData',x,'YData',a,'Color','red','linestyle','--');
line('XData',x,'YData',-a,'Color','red','linestyle','--');
ylabel('自相关系数');
title('模拟信号系数');
subplot(2,1,2);
[PACF,Lags,Bounds] = parcorr(r,n,2);
x = Lags(2:n);
y = PACF(2:n);
h = stem(x,y,'fill','-');
set(h(1),'Master','.');
hold on;
ylim([-1 1]);
b = Bounds(1,1)*ones(1,n-1);
line('XData',x,'YData',b,'Color','red','linestyle','--');
line('XData',x,'YData',-b,'Color','red','linestyle','--');
ylabel('偏自相关系数');
m = 3;
R = reshape(r,m,obv/m);
% 把向量r 变形成 m*(obv/m) 的矩形 R
aggregatedr = sum(R);
% sum(R) 计算矩阵 R 每一列的和，得到的 1*(obv/m)行向量 aggregatedr 就是时频归并后得到的序列
dlmwrite('output.txt',aggregatedr','delimiter','\t','precision',6,'newline','pc');
% 至此完成了对 r 的视频归并'
figure(3);
subplot(2,1,1);
n = 100;
bound = 1;
[ACF,Lags,Bounds] = autocorr(aggregatedr,n,2);
x = Lags(2:n);
y = ACF(2:n);
h = stem(x,y,'fill','-');
set(h(1),'Marker','.');
hold on;
ylim([-bound bound]);
a = Bounds(1,1)*ones(1,n-1);
line('XData',x,'YData',a,'Color','red','linestyle','--');
line('XData',x,'YData',-a,'Color','red','linestyle','--');
ylabel('自相关系数');
title('归并模拟信号系数');
subplot(2,1,2);
[PACF,Lags,Bounds] = parcorr(aggregatedr,n,2);
x = Lags(2:n);
y = PACF(2:n);
h = stem(x,y,'fill','-');
set(h(1),'Marker','.');
hold on;
ylim([-bound bound]);
b = Bounds(1,1) *ones(1,n-1);
line('XData',x,'YData',b,'Color','red','linestyle','--');
line('XData',x,'YData',-b,'Color','red','linestyle','--');
ylabel('偏自相关系数');
t = toc;