I = imread('pout.tif');    	%读取图像
figure; 
subplot(1,2,1);
imshow(I);
title('原图像');
LEN = 31;
THETA = 11;
PSF = fspecial('motion',LEN,THETA); 	%对图像进行退化处理
Blurred = imfilter(I,PSF,'circular','conv');
subplot(1,2,2);
imshow(Blurred);
title('模糊图像');
