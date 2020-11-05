clear all;close all;
co=[1 1 0 1 0 1 0];
ta=0.5e-6;
fc=20e6;
fs=200e6;
t_ta=0:1/fs:ta-1/fs;
n=length(co);
pha=0;
t=0:1/fs:7*ta-1/fs;
s=zeros(1,length(t));
for i=1:n
    if co(i)==1
        pha=1;
    else
        pha=0;
    end
    s(1,(i-1)*length(t_ta)+1:i*length(t_ta))=cos(2*pi*fc*t_ta+pha);
end
figure;plot(t,s);
xlabel('t(单位:秒)');title('二相码(7位巴克码)');
