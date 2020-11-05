clf;
Fs=2000;
N=1024;Nfft=256;
n=0:N-1;t=n/Fs;
window=hanning(256);
noverlap=128;
dflag='none';
randn('state',0);
xn=cos(2*pi*50*t)+2*sin(2*pi*120*t)+randn(1,N);
Pxx=psd(xn,Nfft,Fs,window,noverlap,dflag);
f=(0:Nfft/2)*Fs/Nfft;
plot(f,10*log10(Pxx));
xlabel('频率/Hz');ylabel('功率谱/dB');
title('PSD--Welch方法');
grid on;
