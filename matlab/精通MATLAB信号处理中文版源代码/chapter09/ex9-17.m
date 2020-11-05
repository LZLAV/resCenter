clear all;
[I,map]=imread('trees.tif');
figure;
subplot(121);imshow(I,map);
%指定剪切区域的大小和位置，剪切图像，并返回坐标（x,y）和剪切区域rect
[x,y,I2,rect] = imcrop(I, map,[75 68 130 112]);
subplot(122);imshow(I2);
x,y,rect
