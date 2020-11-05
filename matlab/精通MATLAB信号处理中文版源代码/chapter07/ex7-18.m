clear all;
fs=2000;          %采样频率
h=fir1(20,0.3);
r=randn(1024,1);      %加入的噪声
x=filter(h,1,r);
[pxx1,f]=pcov(x,20,[],fs);
[pxx2,f]=pmcov(x,20,[],fs);
pxx1=10*log10(pxx1);
pxx2=10*log10(pxx2);
plot(f,pxx1,'s',f,pxx2,'g');
ylabel('相对幅度/dB');xlabel('功率谱估计');
legend('协方差法','修正协方差法');
