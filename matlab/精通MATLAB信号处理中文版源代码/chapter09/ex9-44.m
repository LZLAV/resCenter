clear all;
I=imread('canoe.tif');   
subplot(221),
imshow(I);
title('原始图像');
noisy=imnoise(I,'gaussian',0.01);      	%原图中加入高斯噪声
[M N]=size(I);
F=fft2(noisy);
fftshift(F);
Dcut=100;
D0=250;
D1=150;
for u=1:M
    for v=1:N
        D(u,v)=sqrt(u^2+v^2);
EXPOTH(u,v)=exp(log(1/sqrt(2))*(Dcut/D(u,v))^2);	%指数高通滤波器传递函数
        if D(u,v)<D1        	%梯形高通滤波器传递函数
            THFH(u,v)=0;
        elseif D(u,v)<=D0
            THPFH(u,v)=(D(u,v)-D1)/(D0-D1);
        else
            THPFH(u,v)=1;
        end
    end
end
EXPOTG=EXPOTH.*F;
EXPOTfiltered=ifft2(EXPOTG);
THPFG=THPFH.*F;
THPFfiltered=ifft2(THPFG);
subplot(2,2,2),
imshow(noisy)  
title('加入高斯噪声的图像');
subplot(2,2,3), 
imshow(EXPOTfiltered) 
title('指数高通滤波器');
subplot(2,2,4),
imshow(THPFfiltered); 
title('梯形高通滤波器');
