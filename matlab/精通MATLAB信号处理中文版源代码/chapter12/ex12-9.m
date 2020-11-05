clear all;
azi_num=3000; fr=2000;
lamda0=0.025; sigmav=0.5;
sigmaf=2*sigmav/lamda0;
rand('state',sum(100*clock));  %产生服从U(0-1)的随机序列
d1=rand(1,azi_num);
rand('state',7*sum(200*clock)+3);
d2=rand(1,azi_num);
xi=2*sqrt(-2*log(d1)).*sin(2*pi*d2);  % 正交且独立的高斯序列~N(0,1)
coe_num=12;        %求滤波器系数,用傅里叶级数展开法
for n=0:coe_num
    coeff(n+1)=2*sigmaf*sqrt(pi)*exp(-4*sigmaf^2*pi^2*n^2/fr^2)/fr;
end
for n=1:2*coe_num+1
    if n<=coe_num+1
        b(n)=1/2*coeff(coe_num+2-n);
    else
        b(n)=1/2*coeff(n-coe_num);
    end
end
% 生成高斯谱杂波
xxi=conv(b,xi);
xxi=xxi(coe_num*2+1:azi_num+coe_num*2);
xisigmac=std(xxi);
ximuc=mean(xxi);
yyi=(xxi-ximuc)/xisigmac;
muc=10;                  %中位值
sigmac=0.6;        %形状参数
yyi=sigmac*yyi+log(muc); 
xdata=exp(yyi);        % 参数正态分布的杂波序列
num=100;  
maxdat=max(abs(xdata));
mindat=min(abs(xdata));
NN=hist(abs(xdata),num);
xpdf1=num*NN/((sum(NN))*(maxdat-mindat));  %用直方图估计的概率密度函数
xaxis1=mindat:(maxdat-mindat)/num:maxdat-(maxdat-mindat)/num;
th_val=lognpdf(xaxis1,log(muc),sigmac);
subplot(211);plot(xaxis1,xpdf1);
hold on; plot(xaxis1,th_val,'r:');
title('杂波幅度分布');
xlabel('幅度'); ylabel('概率密度');
signal=xdata;
signal=signal-mean(signal); %求功率谱密度,先去掉直流分量
M=128;
psd_dat=pburg(real(signal),16,M,fr);
psd_dat=psd_dat/(max(psd_dat));  %归一化
freqx=0:0.5*M;
freqx=freqx*fr/M;
subplot(212);plot(freqx,psd_dat); 
title('杂波频谱');
xlabel('频率/Hz'); ylabel('功率谱密度');
powerf=exp(-freqx.^2/(2*sigmaf.^2));
hold on; plot(freqx,powerf,'r:');
