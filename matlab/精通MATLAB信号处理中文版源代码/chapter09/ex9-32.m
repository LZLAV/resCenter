I= imread('peppers.png');                 % 读入图像
subplot(2,3,1),imshow(I);              % 显示原始图像
title('原始图像');  
I=rgb2gray(I);          
J=imnoise(I,'salt & pepper',0.03);     % 加均值为 0，方差为 0.03 的椒盐噪声
subplot(2,3,2),imshow(J);              % 显示处理后的图像
title('椒盐噪声');    % 设置图像标题
K = filter2(fspecial('average',3),J)/255;
subplot(2,3,3),imshow(K,[]);           
title('椒盐噪声被滤波后的图像');          
J2=imnoise(I,'gaussian',0.03);        % 加均值为 0，方差为 0.03 的高斯噪声
subplot(2,3,4),imshow(J2);            
title('高斯噪声');         % 设置图像标题
K2 = medfilt2(J2);                     % 图像滤波处理
subplot(2,3,5),imshow(K2,[]);         
title('高斯噪声被滤波后的图像');       
