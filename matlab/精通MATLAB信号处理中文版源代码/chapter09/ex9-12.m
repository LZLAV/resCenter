clear
[A,map]=imread('autumn.tif');             	%读取图像
J=imrotate(A,40,'bilinear');             	%对图像进行旋转
subplot(1,2,1),
imshow(A,map);
title('原始图像')
subplot(1,2,2),
imshow(J,map);
title('旋转后的图像')
