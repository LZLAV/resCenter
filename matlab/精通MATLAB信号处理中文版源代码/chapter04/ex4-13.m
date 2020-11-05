fn=10000;  
fp=[900,1200];  
fs=[600,1700];  
Rp=4;  
Rs=30;
Wp=fp/(fn/2);
%计算归一化角频率
Ws=fs/(fn/2);
[n,Wn]=buttord(Wp,Ws,Rp,Rs);
%计算阶数和截止频率
[b,a]=butter(n,Wn);
%计算H(z)分子、分母多项式系数
[H,F]=freqz(b,a,1000,10000);
%计算H(z)的幅频响应,freqz(b,a,计算点数,采样速率)
subplot(121)
plot(F,20*log10(abs(H)))
axis([0 5000 -30 3])
xlabel('频率 (Hz)'); ylabel('幅值(dB)') 
grid on
subplot(122)
pha=angle(H)*180/pi;
plot(F,pha)
xlabel('频率 (Hz)'); ylabel('相位')
grid on
