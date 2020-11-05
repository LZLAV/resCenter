I=imread('eight.tif');  	%读取图像
figure,
subplot(221);
imshow(I);
title('原图像');
s=fftshift(fft2(I));   	%采用傅里叶变换并移位
subplot(222);
imshow(log(abs(s)),[]);
title('傅变换取对数所得频谱');
[a,b]=size(s);
a0=round(a/2);
b0=round(b/2);
d=10;
p=0.2;q=0.5;
for i=1:a
    for j=1:b
        distance=sqrt((i-a0)^2+(j-b0)^2);
        if distance<=d h=0;
        else h=1;
        end;
        s(i,j)=(p+q*h)*s(i,j);
    end;
end;
s=uint8(real(ifft2(ifftshift(s))));
subplot(223);
imshow(s);
title('高通滤波所得图像');
subplot(224);
imshow(s+I);
title('高频增强图像');
