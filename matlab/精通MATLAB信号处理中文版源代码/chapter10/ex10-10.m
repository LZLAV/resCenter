clear all;
% 在噪声环境下语音信号的增强
sound=wavread('tt.wav');  %语音信号的读入
cound=length(sound);
noise=0.05*randn(1,cound);
y=sound'+noise;
% 获取噪声的阈值
[thr,sorh,keepapp]=ddencmp('den','wv',y);
% 对信号进行消噪
yd=wdencmp('gbl',y,'db4',2,thr,sorh,keepapp);
subplot(1,2,1); plot(sound);
title('原始语音信号');
subplot(1,2,2);plot(yd);
title('去噪后的语音信号');
