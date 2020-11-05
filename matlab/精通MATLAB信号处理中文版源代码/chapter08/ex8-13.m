clear all;
lshaar=liftwave('haar');
%添加到提升方案
els={'p',[-0.25 0.25],0}
lsnew=addlift(lshaar,els);
load noisdopp;
x= noisdopp;
xDec=lwt2(x,lsnew,2)
% 提取第一层的低频系数
ca1=lwtcoef2('ca',xDec,lsnew,2,1)
a1=lwtcoef2('a',xDec,lsnew,2,1)
a2=lwtcoef2('a',xDec,lsnew,2,2)
h1=lwtcoef2('h',xDec,lsnew,2,1)
v1=lwtcoef2('v',xDec,lsnew,2,1)
d1=lwtcoef2('d',xDec,lsnew,2,1)
h2=lwtcoef2('h',xDec,lsnew,2,2)
v2=lwtcoef2('v',xDec,lsnew,2,2)
d2=lwtcoef2('d',xDec,lsnew,2,2)
[cA,cD]=lwt(x,lsnew);
figure(1);
subplot(231);
plot(x);
title('原始信号');
subplot(232);
plot(cA);
title('提升小波分解的低频信号');
subplot(233);
plot(cD);
title('提升小波分解的高频信号');
%直接使用Haar小波进行2层提升小波分解
[cA,cD]=lwt(x,'haar',2);
subplot(234);
plot(x);
title('原始信号');
subplot(235);
plot(cA);
title('2层提升小波分解的低频信号');
subplot(236);
plot(cD);
title('2层提升小波分解的高频信号');
