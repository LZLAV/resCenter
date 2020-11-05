Dt=0.00005;t=-0.005:Dt:0.005;						%模拟信号
xa=exp(-2000*abs(t)); 
Ts=0.0002;n=-25:1:25;								%离散时间信号
x=exp(-1000*abs(n*Ts));
K=500;k=0:1:K;w=pi*k/K;
%离散时间傅立叶变换
X=x*exp(-j*n'*w);X=real(X);
w=[-fliplr(w),w(2:501)];
X=[fliplr(X),X(2:501)];
figure
subplot(2,2,1);
plot(t*1000,xa,'.'); 
ylabel('x1(t)'); xlabel('t');
title ('离散信号');
hold on
stem(n*Ts*1000,x);hold off
subplot(2,2,2);
plot(w/pi,X,'.');
ylabel('X1(jw)'); xlabel('f');
title('离散时间傅立叶变换');
Ts=0.001;n=-25:1:25;
%离散时间信号
x=exp(-1000*abs(n*Ts));
K=500;k=0:1:K;w=pi*k/K;
%离散时间傅立叶变换
X=x*exp(-j*n'*w);X=real(X);
w=[-fliplr(w),w(2:501)];
X=[fliplr(X),X(2:501)];
subplot(2,2,3);
plot(t*1000,xa,'.'); 
ylabel('x2(t)'); xlabel('t');
title ('离散信号');
hold on
stem(n*Ts*1000,x);hold off
subplot(2,2,4);
plot(w/pi,X,'.');
ylabel('X2(jw)'); xlabel('f');
title('离散时间傅立叶变换');
