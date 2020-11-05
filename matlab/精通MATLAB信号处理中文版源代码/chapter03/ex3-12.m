Ts1=0.0002;Fs1=1/Ts1;n1=-25:1:25;nTs1=n1*Ts1;			%离散时间信号
x1=exp(-1000*abs(nTs1));
Ts2=0.001;
Fs2=1/Ts2;
n2=-5:1:5;
nTs2=n2*Ts2;
x2=exp(-2000*abs(nTs2));
Dt=0.00005;t=-0.005:Dt:0.005;							%模拟信号重构
xa1=x1*sinc(Fs1*(ones(length(nTs1),1)*t-nTs1'*ones(1,length(t))));
xa2=x2*sinc(Fs2*(ones(length(nTs2),1)*t-nTs2'*ones(1,length(t))));
subplot(2,1,1);
plot(t*1000,xa1,'.');
ylabel('x1(t)'); xlabel('t');
title('从x1(n)重构模拟信号x1(t)');
hold on
stem(n1*Ts1*1000,x1);
hold off
subplot(2,1,2);
plot(t*1000,xa2,'.');
ylabel('x2(t)'); xlabel('t');
title('从x2(n)重构模拟信号x2(t)');
hold on
stem(n2*Ts2*1000,x2);
hold off
