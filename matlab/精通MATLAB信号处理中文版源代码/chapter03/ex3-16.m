clear all;
dt=0.05;N=1024;
n=0:N-1; t=n*dt;       %时间序列
f=n/(N*dt);            %频率序列
f1=3; f2=10;           %信号的频率成分
x=0.5*cos(2*pi*f1*t)+sin(2*pi*f2*t) +randn(1,N);
subplot(2,2,1);plot(t,x);  %绘制原始的信号
title('原始信号的时间域');xlabel('时间/s');
y=fft(x);        %对原信号作FFT变换
xlim([0 12]);ylim([-1.5 1.5]);
subplot(2,2,2);plot(f,abs(y)*2/N);   %绘制原始信号的振幅谱
xlabel('频率/Hz');ylabel('振幅');
xlim([0 50]);title('原始振幅谱');
ylim([0 0.8]);
f1=4;f2=8;     %要滤去频率的上限和下限
yy=zeros(1,length(y));   %设置与y相同的元素数组
for m=0:N-1    %将频率落在该频率范围及其大于Nyquist频率的波滤去
    % 小于Nyquist频率的滤波范围
    if (m/(N*dt)>f1 & m/(N*dt)<f2) | (m/(N*dt)>(1/dt-f2) & m/(N/dt)<(1/dt-f1));
    % 大于Nyquist频率的滤波范围
    % 1/dt为一个频率周期
    yy(m+1)=0;        %置在此频率范围内的振动振幅为零
    else
        yy(m+1)=y(m+1);   %其余频率范围的振动振幅不变
    end
end
subplot(2,2,4);plot(f,abs(yy)*2/N)   %绘制滤波后的振幅谱
xlim([0 50]);ylim([0 0.5]);
xlabel('频率/Hz');ylabel('振幅');
gstext=sprintf('自%4.1f-%4.1fHz的频率被滤除',f1,f2);
%将滤波范围显示作为标题
title(gstext);
subplot(2,2,3);plot(t,real(ifft(yy)));
%绘制滤波后的数据运用ifft变换回时间域并绘图
title('通过IFFT回到时间域');
xlabel('时间/s');
ylim([-0.6 0.6]);xlim([0 12]);
