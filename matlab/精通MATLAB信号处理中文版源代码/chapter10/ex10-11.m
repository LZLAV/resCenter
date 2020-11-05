clear all;
%语音信号的读入
sound=wavread('tt.wav');  
% 用小波函数haar对信号进行3层分解
[C,L]=wavedec(sound,3,'haar');
alpha=1.5;
% 获取信号压缩的阈值
[thr,nkeep]=wdcbm(C,L,alpha);
% 对信号进行压缩
[cp,cxd,lxd,per1,per2]=wdencmp('lvd',C,L,'haar',3,thr,'s');
subplot(1,2,1); plot(sound);
title('原始语音信号');
subplot(1,2,2);plot(cp);
title('压缩后的语音信号');
