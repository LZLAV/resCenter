clear all;
A1=imread('rice.png');
A2=imread('cameraman.tif');
K=imlincomb(0.3,A1,0.3,A2);
subplot(1,3,1),subimage(A1);
title('原始图像rice')
subplot(1,3,2),
subimage(A2);
title('原始图像cameraman')
subplot(1,3,3),
subimage(K);  
title('图像平均')
