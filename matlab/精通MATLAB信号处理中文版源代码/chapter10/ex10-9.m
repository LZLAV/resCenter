clear all;
% 在噪声环境下语音信号的增强
sound=wavread('tt.wav');  %语音信号的读入
cound=length(sound);
noise=0.05*randn(1,cound);
y=sound'+noise;
% 用小波函数'db6'对信号进行3层分解
[C,L]=wavedec(y,3,'db6');
% 估计尺度1的噪声标准偏差
sigma=wnoisest(C,L,1);
alpha=2;
% 获取消噪过程中的阈值
thr=wbmpen(C,L,sigma,alpha);
keepapp=1;
% 对信号进行消噪
yd=wdencmp('gbl',C,L,'db6',3,thr,'s',keepapp);
subplot(1,2,1); plot(sound);
title('原始语音信号');
subplot(1,2,2);plot(yd);
title('去噪后的语音信号');
