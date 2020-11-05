clear all;
I=imread('football.jpg');  %I为原始图像
figure;
subplot(131);imshow(I); %显示原始图像
title('原始图像')
I=double(I);
I_en=imresize(I,4,'nearest');  %最近邻法标志函数nearest扩大4倍
subplot(132);imshow(uint8(I_en)); %显示扩大4倍后的图像
title('扩大4倍后的图像')
I_re=imresize(I,0.5,'nearest');  %缩小两倍
subplot(133);imshow(uint8(I_re));%显示缩小2倍后的图像
title('缩小2倍后的图像')
