% 其他滤波器
% 维纳滤波器、卡尔曼滤波器、自适应滤波器、格型滤波器

clear all;
close all;
clc;

% 维纳滤波器示例
L = input('请输入信号长度L=');
N = input('请输入滤波器阶数 N=');
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
