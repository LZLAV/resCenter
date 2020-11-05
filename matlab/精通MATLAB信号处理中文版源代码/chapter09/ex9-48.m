clc
I=imread('coins.png');       	%读取图像
subplot(2,2,1);
imshow(I);
title('原始图像');
[m,n]=size(I);
F=fftshift(fft2(I));
k=0.0025;
H=[];
for u=1:m 
    for  v=1:n
        q=((u-m/2)^2+(v-n/2)^2)^(5/6);
        H(u,v)=exp((-k)*q);
    end
end
G=F.*H;
I0=abs(ifft2(fftshift(G)));
subplot(2,2,2);
imshow(uint8(I0));
title('退化的图像');
I1=imnoise(uint8(I0),'gaussian',0,0.01)  	%退化并且添加高斯噪声的图像
subplot(2,2,3);
imshow(uint8(I1));
title('退化并且添加高斯噪声的图像');
F0=fftshift(fft2(I1));
F1=F0./H;
I2=ifft2(fftshift(F1));               	%逆滤波复原图
subplot(2,2,4);
imshow(uint8(I2));
title('逆滤波复原图');
