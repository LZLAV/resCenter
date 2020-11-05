I=imread('office_4.jpg');
I1=rgb2gray(I);
subplot(1,2,1),imshow(I1);
title('灰度图像');
axis([50,250,50,200]);
grid on;          	%显示网格线
axis on;       	%显示坐标系
J=double(I1);
J=40*(log(J+1));
H=uint8(J);
subplot(1,2,2),
imshow(H);
title('对数变换图像');
axis([50,250,50,200]);
grid on; 
axis on;     
