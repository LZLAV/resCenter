clear;
close all;
[image_0,map]=imread('canoe.tif');  	%读取图像
image_1=log(double(image_0)+1);  
image_2=fft2(image_1);
n=3;
D0=0.05*pi;              	%通过变换参数可以对滤波效果进行调整
rh=0.9;
rl=0.3;
[row,col]=size(image_2);
for k=1:1:row
    for l=1:1:col
       D1(k,l)=sqrt((k^2+l^2));
       H(k,l)=rl+(rh/(1+(D0/D1(k,l)^(2*n))));
      end
end
image_3=(image_2.*H);
image_4=ifft2(image_3);
image_5=(exp(image_4)-1);
subplot( 121),
imshow(image_0,map)
title('原始图像')
subplot( 122),
imshow(real(image_5),map)
title('同态滤波')
