%绘制情况(a)系统零极点分布图及系统单位序列响应 
z=0;							%定义系统零点位置 
p=0.25;						%定义系统极点位置 
k=1;							%定义系统增益
subplot(221)
zplane(z,p)
grid on;
%绘制系统零极点分布图
subplot(222);
[num,den]=zp2tf(z,p,k);			%零极点模型转换为传递函数模型 
impz(num,den)
%绘制系统单位序列响应时域波形 
title('h(n)')
grid on;
%定义标题 
%绘制情况(b)系统零极点分布图及系统单位序列响应 
p=1; 
subplot(223);
zplane(z,p)
grid on;
[num,den]=zp2tf(z,p,k); 
subplot(224);
impz(num,den) 
title('h(n)') 
grid on;
