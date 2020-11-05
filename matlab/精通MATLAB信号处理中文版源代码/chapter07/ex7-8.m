clear all;
Fs=1000;
NFFT=256;
p=0.98;     %置信区间
[b,a]=ellip(5,2,50,0.2);   %设计5阶椭圆型滤波器
r=randn(4096,1);
x=filter(b,a,r);        %对白噪声滤波得到信号x
psd(x,NFFT,Fs,[],0,p);   %PSD估计
xlabel('频率/Hz');ylabel('相对功率谱密度(dB/Hz)');
