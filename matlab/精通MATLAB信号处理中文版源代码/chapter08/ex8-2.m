clear all;
randn('seed',234343285);        %定义随机信号的状态
s =4 + kron(ones(1,8),[1 -1]) + ((1:16).^2)/24 + 0.3*randn(1,16);
% 用小波函数db2对信号进行单尺度一维小波分解
[ca1,cd1] = dwt(s,'db2'); 
subplot(221); plot(ca1); 
title('重构低通'); 
subplot(222); plot(cd1); 
title('重构高通');
ss = idwt(ca1,cd1,'db2'); 
err = norm(s-ss);    
subplot(212); plot([s;ss]'); 
title('原始、重构后的信号的误差'); 
xlabel(['重构误差 ',num2str(err)])
[Lo_R,Hi_R] = wfilters('db2','r'); 
ss = idwt(ca1,cd1,Lo_R,Hi_R);
