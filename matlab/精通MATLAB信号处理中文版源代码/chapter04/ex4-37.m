dt=1/2000;
t=0:dt:0.1;         %给出模拟滤波器输出的时间范围
% 模拟输入信号
u=tan(2*pi*30*t)+0.5* sin (2*pi*300*t)+2* cos (2*pi*800*t);
subplot(2,2,1);plot(t,u)   %绘制模拟输入信号
xlabel('时间/s');title('输入信号');
[ys,ts]=lsim(H,u,t);       %模拟系统的输入u时的输出
subplot(2,2,2);plot(ts,ys); %绘制模拟输入信号
xlabel('时间/s');title('输出信号');
% 绘制输入信号振幅谱
subplot(2,2,3);plot((0:length(u)-1)/(length(u)*dt),abs(fft(u))*2/length(u));
xlabel('频率/Hz');title('输入信号振幅谱');
subplot(2,2,4);
Y=fft(ys);
%绘制输出信号振幅谱
plot((0:length(Y)-1)/(length(Y)*dt),abs(Y)*2/length(Y));
xlabel('频率/Hz');title('输出信号振幅谱');
