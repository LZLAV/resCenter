clear all;
n=0:200-1;
f=200;  fs=3000;
x=cos(2*pi*n*f/fs);
y=dct(x);   %计算DCT变换
m=find(abs(y<5));  %利用阈值对变换系数截取
y(m)=zeros(size(m));
z=idct(y);   %对门限处理后的系数DCT反变换
subplot(1,2,1);plot(n,x);
xlabel('n');title('序列x(n)');
subplot(1,2,2);plot(n,z);
xlabel('n');title('序列z(n)');
