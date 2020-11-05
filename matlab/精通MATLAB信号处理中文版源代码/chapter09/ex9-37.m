I=imread('coins.png');%读入图像
subplot(2,2,1),
imshow(I);
title('原始图像');%显示原图像
H=fspecial('sobel'); %应用sobel算子锐化图像
I2=filter2(H,I); %sobel算子滤波锐化
subplot(2,2,2);
imshow(I2); %显示sobel算子锐化图像
title('sobel算子锐化图像');
H1=fspecial('prewitt');%应用prewitt算子锐化图像
I3=filter2(H1,I);%prewitt算子滤波锐化
subplot(2,2,3);imshow(I3); %显示prewitt算子锐化图像
title('prewitt算子锐化图像');
H2=fspecial('log'); %应用log算子锐化图像
I4=filter2(H2,I); %log算子滤波锐化
subplot(2,2,4);
imshow(I4);%显示log算子锐化图像
title('log算子锐化图像');
