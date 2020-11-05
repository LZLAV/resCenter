clear all;
I=imread('rice.png');
I1=uint16(I);       %转换图像为uint16类型
I2=immultiply(I1,I1);  %图像自乘
I3=immultiply(I,1.2);  %图像扩大像素
I4=immultiply(I,0.6);    %图像缩小像素
subplot(2,2,1),imshow(I);
title ('原始图像')
subplot(2,2,2),
imshow(I2);
title ('图像自乘')
subplot(2,2,3),
imshow(I3);
title ('图像扩大像素')
subplot(2,2,4),
imshow(I4); 
title ('图像缩小像素')
