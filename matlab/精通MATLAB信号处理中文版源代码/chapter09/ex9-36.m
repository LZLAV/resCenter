clear all;
[I,map]=imread('trees.tif');
subplot(2,2,1);imshow(I);
title('原始图像');
I=double(I);                    %数据类型转换
[IX,IY]=gradient(I);            %梯度
gm=sqrt(IX.*IX+IY.*IY);
out1=gm;
subplot(2,2,2);imshow(out1,map);
title('梯度值');
out2=I;
J=find(gm>=15);      %阈值处理
out2(J)=gm(J);
subplot(2,2,3);imshow(out2,map);
title('对梯度值加阈值');
out3=I;
J=find(gm>=20);      %阈值黑白化
out3(J)=255;         %设置为白色
K=find(gm<20);       %阈值黑白化
out3(K)=0;           %设置为黑色
subplot(2,2,4);imshow(out3,map);  
title('二值化处理')
