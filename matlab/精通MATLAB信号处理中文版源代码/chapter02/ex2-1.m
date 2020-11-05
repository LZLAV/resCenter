clear all;
N=[-3 -2 -1 0 1 3 3 2 5 6 7 6 9 11];  %为序号序列
X=[0 2 3 3 2 3 0 -1 -2 -3 -4 -5 1 2]; %为值序列
subplot(2,1,1);stem(N,X);  %绘制离散值图
hold on;
plot(N,zeros(1,length(X)),'r');
%绘制横轴,zeros(1,N)为产生1行N列元素值为零的数组
set(gca,'box','on');  %产生坐标轴设在方框上
xlabel('序列号');ylabel('序列值');
dt=1;      %时间间隔
t=N*dt;    %时间序列
subplot(2,1,2);plot(t,X);  %绘制随时间的变化
hold on;
plot(t,zeros(1,length(X)),'r');  %绘出横轴
xlabel('时间/s');ylabel('函数值');
