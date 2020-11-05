I=imread('peppers.png');       	%读入图像
PSF=fspecial('motion',10,30); 
Blurred=imfilter(I,PSF,'circ','conv') ;
INITPSF=ones(size(PSF)); 
[J P]=deconvblind (Blurred,INITPSF,20); 	%对图像进行盲去卷积滤波复原
figure
subplot(1,3,1);
imshow (I);
title('原始图像');
subplot(1,3,2);
imshow (Blurred);
title('模糊后的图像')
subplot(1,3,3);
imshow (J);
title('恢复后的图像');
