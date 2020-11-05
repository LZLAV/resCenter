clear all;
a = [1 -2.3147 2.9413 -2.1187 0.9105];      %定义AR模型
[H,w] = freqz(1,a,256);     % AR 模型的频率响应
Hp = plot(w/pi,20*log10(2*abs(H)/(2*pi)),'r'); 
hold on;
randn('state',0);
x = filter(1,a,randn(256,1));           % AR 模型输出
pburg(x,4,511); 
xlabel('频率/Hz')
ylabel('相对功率谱密度(dB/Hz)');
title('Burg法PSD估计');
legend('PSD模型输出','PSD谱估计');
grid on;
