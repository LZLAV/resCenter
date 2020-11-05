I=imread('office_4.jpg');               	%读取图像
figure;
subplot(221)
;imshow(I);
title('原始图像')
I=double(I);
h=size(I);
I_fliplr(1:h(1),1:h(2),1:h(3))=I(1:h(1),h(2):-1:1,1:h(3)); 	%水平镜像变换
I1=uint8(I_fliplr);
subplot(222);
imshow(I1);
title('水平镜像变换')
I_flipud(1:h(1),1:h(2),1:h(3))=I(h(1):-1:1,1:h(2),1:h(3)); 	%垂直镜像变换
I2=uint8(I_flipud);
subplot(223);
imshow(I2);
title('垂直镜像变换')
I_fliplr_flipud(1:h(1),1:h(2),1:h(3))=I(h(1):-1:1,h(2):-1:1,1:h(3));	%对角镜像变换
I3=uint8(I_fliplr_flipud);
subplot(224);
imshow(I3);
title('对角镜像变换')
