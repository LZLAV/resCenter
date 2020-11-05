randn('state',0);
noise=randn(40000,1);  %正态高斯白噪声
x=filter(1,[1 1/2 1/3 1/4],noise);
x=x(35904:40000);
%调用线性预测函数lpc，计算预测系数，并估算预测误差以及预测误差的自相关。
a=lpc(x,3);
est_x=filter([0 -a(2:end)],1,x);  %信号估算
e=x-est_x;               %预测误差
[acs,lags]=xcorr(e,'coeff');  %预测误差的ACS
%比较预测信号和原始信号，如图8-8所示
subplot (211);
plot(1:97,x(3001:3097),1:97,est_x(3001:3097),'--');
title('比较预测信号和原始信号'); 
xlabel('Sample Number');ylabel('Amplitude');
grid on;
%分析预测误差的自相关， 
subplot (212);
plot(lags,acs);
title('分析预测误差的自相关');
xlabel('Lags');
ylabel('Normalized Value');
grid on;
