clear all;
I=checkerboard(40);           %创建一个棋盘
F=fft2(I);
subplot(1,2,1);
imshow(I);
title('原始图像');
subplot(1,2,2);
imshow(F);
title('二维傅里叶变换')
