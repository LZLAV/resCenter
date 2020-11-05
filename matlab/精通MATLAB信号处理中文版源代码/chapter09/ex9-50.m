I=imread ('cell.tif'); 
PSF=fspecial('gaussian',10,4); 
Blurred=imfilter(I,PSF,'conv'); 
V=.03;
BN=imnoise(Blurred,'gaussian',0,V); 
NP=V*prod(size(I)); 
[reg LAGRA]=deconvreg(BN,PSF,NP); 
Edged=edgetaper(BN,PSF); 
reg2=deconvreg(Edged,PSF,NP/1.2);    	%振铃抑制
reg3=deconvreg(Edged,PSF,[],LAGRA); 	%拉格朗日算子
figure
subplot(2,3,1);
imshow (I);
title('原始图像');
subplot(2,3,2);
imshow (BN);
title('加入高斯噪声的图像');
subplot(2,3,3);
imshow (reg);
title('恢复后的图像');
subplot(2,3,4);
imshow(reg2);
title('振铃抑制图像');
subplot(2,3,5);
imshow(reg3);
title('拉格朗日算子恢复图像');
