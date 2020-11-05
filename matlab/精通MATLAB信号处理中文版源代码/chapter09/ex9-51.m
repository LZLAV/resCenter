I=imread ('football.jpg');       	%读取图像
PSF=fspecial('gaussian',5,5) ;
Blurred=imfilter(I,PSF,'symmetric','conv'); 
V=.003; 
BN=imnoise(Blurred,'gaussian',0,V); 
luc=deconvlucy(BN,PSF,5);  	%进行Lucy-Richardson滤波恢复复原
figure
subplot(2,2,1);
imshow(I);
title('原始图像');
subplot(2,2,2);
imshow (Blurred);
title('模糊后的图像');
subplot(2,2,3);
imshow (BN);
title('加噪后的图像');
subplot(2,2,4);
imshow (luc);
title('恢复后的图像');
