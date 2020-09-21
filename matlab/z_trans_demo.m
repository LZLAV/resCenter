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
