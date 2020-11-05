clear
tic
%s设定ARMA模型的多项式系数。ARMA模型中只有多项式A(q)和C(q)，
a1 = -(0.6)^(1/3);
a2 = (0.6)^(2/3);
a3 = 0;
a4 = 0;
c1 = 0;
c2 = 0;
c3 = 0;
c4 = 0; 
obv = 3000;
%obv是模拟的观测数目。 
A = [1 a1 a2 a3 a4];
B = [];
%因为ARMA模型没有输入，因此多项式B是空的。
C = [1 c1 c2 c3 c4];
D = [];
%把D也设为空的。
F = [];
%ARMA模型里的F多项式也是空的。
m = idpoly(A,B,C,D,F,1,1)
%这样就生成了ARMA模型，把它存储在m中。抽样间隔Ts设为1。 
error = randn(obv, 1);
%生成一个obv*1的正态随机序列。准备用作模型的误差项。
e = iddata([],error,1);
%用randn函数生成一个噪声序列。存储在e中。抽样间隔是1秒。
%u = [];
%因为是ARMA模型，没有输出。所以把u设为空的。
y = sim(m,e); 
get(y)
%使用get函数来查看动态系统的所有性质。
r=y.OutputData; 
%把y.OutputData的全部值赋给变量r，r就是一个obv*1的向量。 
figure(1)
plot(r)
title('模拟信号');
ylabel('幅值');
xlabel('时间')
%绘出y随时间变化的曲线。 
figure(2)
subplot(2,1,1)
n=100;
[ACF,Lags,Bounds]=autocorr(r,n,2);
x=Lags(2:n);
y=ACF(2:n);
%注意这里的y和前面y的完全不同。
h=stem(x,y,'fill','-');
set(h(1),'Marker','.')
hold on
ylim([-1 1]); 
a=Bounds(1,1)*ones(1,n-1);
line('XData',x,'YData',a,'Color','red','linestyle','--')
line('XData',x,'YData',-a,'Color','red','linestyle','--')
ylabel('自相关系数')
title('模拟信号系数');
subplot(2,1,2)
[PACF,Lags,Bounds]=parcorr(r,n,2);
x=Lags(2:n);
y=PACF(2:n);
h=stem(x,y,'fill','-');
set(h(1),'Marker','.')
hold on
ylim([-1 1]);
b=Bounds(1,1)*ones(1,n-1);
line('XData',x,'YData',b,'Color','red','linestyle','--')
line('XData',x,'YData',-b,'Color','red','linestyle','--')
ylabel('偏自相关系数')  
m = 3;
R = reshape(r,m,obv/m); 
% 把向量 r 变形成m*(obv/m)的矩阵R. 
aggregatedr = sum(R);
% sum(R)计算矩阵R每一列的和。得到的1*(obv/m)行向量aggregatedr就是时频归并后得到的序列。
dlmwrite('output.txt',aggregatedr','delimiter','\t','precision',6,'newline','pc');
% 至此完成了对r的时频归并。 
figure(3)
subplot(2,1,1) 
n=100;
bound = 1;
[ACF,Lags,Bounds]=autocorr(aggregatedr,n,2);
x=Lags(2:n);
y=ACF(2:n); 
h=stem(x,y,'fill','-');
set(h(1),'Marker','.')
hold on
ylim([-bound bound]); 
a=Bounds(1,1)*ones(1,n-1);
line('XData',x,'YData',a,'Color','red','linestyle','--')
line('XData',x,'YData',-a,'Color','red','linestyle','--')
ylabel('自相关系数')
title('归并模拟信号系数');
subplot(2,1,2)
[PACF,Lags,Bounds]=parcorr(aggregatedr,n,2);
x=Lags(2:n);
y=PACF(2:n);
h=stem(x,y,'fill','-');
set(h(1),'Marker','.')
hold on
ylim([-bound bound]);
b=Bounds(1,1)*ones(1,n-1);
line('XData',x,'YData',b,'Color','red','linestyle','--')
line('XData',x,'YData',-b,'Color','red','linestyle','--')
ylabel('偏自相关系数')  
t=toc;
