
clear;
clf;
dt = 0.001;
t = -1:dt:2.5;
f1 = heaviside(t) -0.5*heaviside(t-2);
f2 = 2*exp(-3*t).*heaviside(t);
f = conv(f1,f2)*dt;
n = length(f);
tt = (0:n-1)*dt -2;
subplot(221);
plot(t,f1);
grid on;
axis([-1,2.5,-0.2,1.2]);
title('f1(t)');
xlabel('t');
ylabel('f1(t)');
subplot(222);
plot(t,f2);
grid on;
axis([-1,2.5,-0.2,1.2]);
title('f2(t)');
xlabel('t');
ylabel('f2(t)');
subplot(212);
plot(tt,f);
grid on;
title('卷积积分');
xlabel('t');
ylabel('f3(t)');