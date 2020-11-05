I=imread('rice.png');   %读入rice图像；
J=imread('cameraman.tif');   %读入cameraman图像；
K=imadd(I,J,'uint16');   %图像相加，并把结果存为16位的形式；
figure;
subplot(1,3,1);
imshow(I);
 title('rice原始图像');
subplot(1,3,2);
imshow(J);
 title('cameraman原始图像');
subplot(1,3,3);
imshow(K,[]);   %注意把结果压缩到0-255范围之内显示
title('相加图像');
