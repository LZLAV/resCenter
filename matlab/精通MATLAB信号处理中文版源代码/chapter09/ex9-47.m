I=imread('football.jpg');  	%读入图像
subplot(221);
imshow(I);
title('原始图像');
H=fspecial('motion',30,45);	%运动模糊PSF
MotionBlur=imfilter(I,H);  	%卷积
subplot(222);
imshow(MotionBlur);
title('运动模糊图像');
H=fspecial('disk',10);    	%圆盘状模糊PSF
bulrred=imfilter(I,H);
subplot(223);
imshow(bulrred);
title('圆盘状模糊图像');
H=fspecial('unsharp');   	%钝化模糊PSF
Sharpened=imfilter(I,H);
subplot(224);
imshow(Sharpened);
title('钝化模糊图像');
