clear all;
bw = imread('circbw.tif');
bw2 = imcomplement(bw);
subplot(2,3,1),
imshow(bw)
title('二值原始图像')
subplot(2,3,4),
imshow(bw2)
title('二值图像求补')
I = imread('cell.tif');
J = imcomplement(I);
subplot(2,3,2),
imshow(I)
title('灰度原始图像')
subplot(2,3,5),imshow(J)
title('灰度图像求补')
RGB=imread('onion.png');
RGB1=imcomplement(RGB);
subplot(2,3,3),imshow(RGB)
title('RGB原始图像')
subplot(2,3,6),
imshow(RGB1)
title('RGB图像求补')
