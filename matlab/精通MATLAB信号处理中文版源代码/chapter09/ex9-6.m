clear all;
I = imread('pout.tif');
J = imlincomb(1.5,I);
subplot(1,2,1);
imshow(I);
title('原始图像')
subplot(1,2,2);
imshow(J)
title('放大1.5后图像')
