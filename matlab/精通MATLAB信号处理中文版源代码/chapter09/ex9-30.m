a=imread('tire.tif');          %读取原始图像
subplot(1,3,1),
imshow(a);                 %显示原始图像
title('原始图像');
%显示函数的曲线图
x=1:255;
y=x+x.*(255-x)/255;
subplot(1,3,2),
plot(x,y);                   %绘制的曲线图
title('函数的曲线图');
b1=double(a)+0.006*double(a) .*(255-double(a));
subplot(1,3,3),
imshow(uint8(b1));           %显示非线性处理图像
title('非线性处理效果');
