clear;clc;close all;
L = 40;       %RLS 均衡器的长度为30；
delta = 0.2;
lamda = 0.98;
n_max = 500;
Fs=500;     %抽样率为1000Hz；
F0 = 10;
w = zeros(L,1);
d = zeros(L,1);
u = zeros(L,1);
P = eye(L)/delta;
h=[-0.006,0.011,-0.023,0.764,-0.219,0.039,-0.0325];
for t=1:L-1
d(t) = sin(2*pi*F0*t/Fs);
end
input=d;
for t=L:n_max
    input(t) = sin(2*pi*F0*t/Fs);
    for i=2:L
        d(L-i+2) = d(L-i+1);
    end
    d(1) = input(t);
    u=filter(h,1,d);
    u=awgn(u,30,'measured');
    output = w'*u;
    k = (P*u)/(lamda + u'*P*u);
    E = d(1) - w'*u;
    w = w + k*E;
    P = (P/lamda) - (k*u'*P/lamda);
    indata(t-L+1) = u(1);
    oudata(t-L+1) = output;
    err(t-L+1) = E;
end
subplot(411),plot(input),title('发送信号');
subplot(412),plot(indata),title('接收信号');
subplot(413),plot(oudata),title('RLS均衡后出信号');
subplot(414),plot(err),title('误差信号');
