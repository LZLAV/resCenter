clear all;
I = imread('coins.png');
subplot(221);imshow(I);
title ('原始图像')
background = imopen(I,strel('disk',15));
Ip = imdivide(I,background);
subplot(222);
imshow(Ip,[])
title ('图像与背景相除')
J = imdivide(I,3);
subplot(2,2,3),
 imshow(J)
title ('图像与3相除效果')
K = imdivide(I,0.6);
subplot(2,2,4), 
imshow(K)
title ('图像与0.6相除效果')
