clear;

%{
% Z 变换与反变换
f = str2sym('cos(a*k)');
F = ztrans(f);  % Z 变换
disp(F);
disp(f);
F= str2sym('z^2/((1+z)*(z-2))');
f = iztrans(F);
disp(F);
disp(f);
%}

% 系统的零点分布及其稳定性
% 求 H(z) = (z^3+2z)/(z^4+3(z^3) + 2(z^2) +2z+1) 的零极点及其分布图
% 求 H(z) = (1+z^(-1))/(1+z^-1/2 +z^-2/4) 的零极点及其分布图
% 采用 roots 和 plot 函数
%(1)
%{
 b =[1,0,2,0];
 a = [1,3,2,2,1];
 zsl = roots(b);
 psl = roots(a);
 figure(1);
 subplot(2,1,1);
 plot(real(zsl),imag(zsl),'o',real(psl),imag(psl),'kx','markersize',12);
 axis([-2,2,-2,2]);
 grid on;
 legend('零点','极点');
 
 %(2)
 c = [1,1,0];
 d = [1,1/2,1/4];
 zs2 = roots(c);
 ps2 = roots(d);
 subplot(2,1,2);
 plot(real(zs2),imag(zs2),'o',real(ps2),imag(ps2),'kx','markersize',12);
 axis([-2,2,-2,2]);
 grid on;
 legend('零点','极点');
 
 % 采用 tf2zp 和 zplane 函数
 %(1)
 b = [1,0,2,0];
 a =[1,3,2,2,1];
 figure(2);
 [z,p] = tf2zp(b,a);
 subplot(2,1,1);
 zplane(z,p);
 %(2)
 c = [1,1,0];
 d = [1,1/2,1/4];
 [z,p] = tf2zp(c,d);
 subplot(2,1,2);
 zplane(z,p);
 %}
 
 
 % 系统的零极点分布与系统冲激响应时域特性
 %{
 a = [1 -2*0.8*cos(pi*4) 0.8^2];
 b = [1];
 [z,p,k] = tf2zp(b,a);
 figure(1);
 subplot(2,1,1),zplane(z,p);
 subplot(2,1,2),impz(b,a,20);
 %}
 
 %  离散系统的频率响应
 %{
 [H,w] = freqz(b,a,N);
 [H,w] = freqz(b,a,N,'whole');
 freqz(b,a,N);
 freqz(b,a,N,'whole');
 %}

 
%幅频特性和相频特性
%{
b = [5/4 -5/4];
a =[1 -1/4];
[h,w] = freqz(b,a,400,'whole');
hf = abs(h);
hx = angle(h);
figure(1),clf;
subplot(2,1,1),plot(w,hf),title('幅频特性曲线'),grid on;
subplot(2,1,2),plot(w,hx),title('相频特性曲线'),grid on;
figure(2);
freqz(b,a,'whole');

%
[z,p] = tf2zp(b,a);
r = 2;
k = 200;
w = 0:1*pi/k:r*pi;
y = exp(1i*w);
N = length(p);
M = length(z);
yp = ones(N,1)*y;
yz = ones(M,1)*y;
vp = yp -p*ones(1,r*k+1);
vz = yz-z*ones(1,r*k+1);
Ai = abs(vp);
Bj = abs(vz);
Ci = angle(vp);
Dj = angle(vz);
fai = sum(Dj,1) - sum(Ci,1);
H = prod(Bj,1)./prod(Ai,1);
figure(3);
subplot(2,1,1),plot(w,H),title('离散系统幅频特性曲线'),xlabel('角频率'),ylabel('幅度');
subplot(2,1,2),plot(w,fai),title('离散系统的相频特性曲线'),xlabel('角频率'),ylabel('相位');
%}


% Z反变换，留数法
%{
close all;
clc;
B = poly([-0.4 -04]);   % poly(r),其中r是向量，返回其根是r元素的多项式的系数。
A = poly([-0.8 -0.8 0.5 0.5 -0.1]);
[R P K] = residuez(B,A);
R = R'
P = P'
K
%}

%{
a = [3 -2 0 0 0 1];
b = [2 1];
ljdt(a,b);
p = roots(a);
q = roots(b);
pa = abs(p)
%}

%{
% 绘制系统零极点分布图及系统单位序列响应
z = 0;      % 定义系统零点位置
p = 0.25;   % 定义系统极点位置
k = 1;      % 定义系统增益
subplot(221);
zplane(z,p)
grid on;
%绘制系统零极点分布图
subplot(222);
[num,den] = zp2tf(z,p,k);   % 零极点模型转换为传递函数模型
impz(num,den);
% 绘制系统单位序列响应时域波形
title('h(n)');
grid on;
% 定义标题
% 绘制系统零极点分布图及系统单位序列响应
p = 1;
subplot(223);
zplane(z,p);
grid on;
[num,den] = zp2tf(z,p,k);
subplot(224);
impz(num,den)
title('h(n)')
grid on;
%}

num = [0.55 0.5 -1];
den = [1 -0.5 -0.45];
x0 = [2 3];
y0 = [1 2];
N = 50;
n = [0:N-1];
x = 0.7.^n;
Zi = filtic(num,den,y0,x0);
[y,Zf] = filter(num,den,x,Zi);
plot(n,x,'r--',n,y,'b--');
title('响应');
xlabel('n');
ylabel('x(n)-y(n)');
legend('输入x','输入y');