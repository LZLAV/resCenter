clear all;   %利用拉普拉斯算子对模糊图像进行增强
I=imread('rice.png');
subplot(1,2,1);imshow(I);
title('原始图像');
I=double(I);  %转换数据类型为double双精度型
H=[0 1 0,1 -4 1,0 1 0];  %拉普拉斯算子
J=conv2(I,H,'same');  %用拉普拉斯算子对图像进行二维卷积运算
K=I-J; 
subplot(1,2,2),imshow(K,[])
title('锐化滤波处理')
