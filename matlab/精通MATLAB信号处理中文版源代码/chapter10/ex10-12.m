clear all;
%语音信号的读入
sound=wavread('tt.wav');  
% 用小波函数haar对信号进行5层分解
[C,L]=wavedec(sound,5,'haar');
% 获取信号压缩的阈值
[thr,nkeep]=ddencmp('cmp','wv',sound);
% 对信号进行压缩
cp=wdencmp('gbl',C,L,'haar',5,thr,'s',1);
subplot(1,2,1); plot(sound);
title('原始语音信号');
subplot(1,2,2);plot(cp);
title('压缩后的语音信号');
