I=imread('rice.png');
subplot(131),
imshow(I);
title('原始图像');
H=hadamard(256);
%hadamad矩阵
I=double(I)/255;        	%数据类型转换
hI=H*I*H; %Hadamard变换
hI=hI/256;
subplot(132)
imshow(hI);
title('二维离散Hadamard变换');
subplot(133)
cI=dct2(I);        	%离散余弦变换
imshow(cI);
title('二维离散余弦变换');
