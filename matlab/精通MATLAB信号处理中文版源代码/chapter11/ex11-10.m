function [s,a]= Signal(M,L,iniphase)
xx=[0:1:M-1]';
a=pskmod(xx,M,iniphase);
aa=randint(L,1,M);
s = pskmod(aa,M,iniphase);
s = s.';
运行程序如下：
clear;clc;close all;
ii=sqrt(-1);
L=1000;    % 总符号数
dB=40;     % 信噪比
h=[-0.004-ii*0.003,0.008+ii*0.02,-0.014-ii*0.105,0.864+ii*0.521,-0.328+ii*0.274,...
0.059-ii*0.064,-0.017+ii*0.02,0];
M=4;
iniphase=pi/4;
[s,a]= PSKSignal(M,L,iniphase);
R=mean(abs(a).^4)/mean(abs(a).^2);
r=filter(h,1,s);
c=awgn(r,dB,'measured');
subplot(311);
plot(a,'.');
title('发送信号');
subplot(312);
plot(c,'.');
title('接收信号');
Nf=7;
f=zeros(Nf,1);
f((Nf+1)/2)=1;
mu=0.01;
ycma=[];
for k=1:L-Nf
    c1=c(k:k+Nf-1);
    xcma(:,k)=fliplr(c1).';
    y(k)=f'*xcma(:,k);
    e(k)=y(k)*(abs(y(k))^2-R); 
    f=f-mu*conj(e(k))*xcma(:,k);
    ycma=[ycma,y(k)];    
    q(k,:)=conv(f',h);
    isi(k)=sum(abs(q(k,:)).^2)/max(abs(q(k,:)))^2-1;
    isilg(k)=10*log10(isi(k));
end
subplot(313);
plot(ycma(1:end),'.');
title('均衡器输出信号');
