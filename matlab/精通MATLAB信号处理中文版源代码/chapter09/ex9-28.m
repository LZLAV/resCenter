A=imread('gantrycrane.png');
I=rgb2gray(A);
I=im2double(I);            	%转换图像矩阵为双精度型。
T=dctmtx(8);             	%产生二维DCT变换矩阵
a1 = [ 16    11    10    16    24    40    51    61
     12    12    14    19    26    58    60    55
     14    13    16    24    40    57    69    56
     14    17    22    29    51    87    80    62
     18    22    37    56    68   109   103    77
     24    35    55    64    81   104   113    92
     49    64    78    87   103   121   120   101
     72    92    95    98   112   100   103    99];
for i=1:8:200
    for j=1:8:200
        P=I(i:i+7,j:j+7);
        K=T*P*T';
        I2(i:i+7,j:j+7)=K;
        K=K./a1;                	%量化
        K(abs(K)<0.03)=0;
        I3(i:i+7,j:j+7)=K;
    end
end
subplot(2,2,2);
imshow(I2);
title('DCT变换后的频域图像');    	%显示DCT变换后的频域图像
for i=1:8:200
    for j=1:8:200
        P=I3(i:i+7,j:j+7).*a1;          	%反量化
        K=T'*P*T;
        I4(i:i+7,j:j+7)=K;
    end
end
subplot(2,2,4);
imshow(I4);
title('复原图像');
B=blkproc(I,[8,8],'P1*x*P2',T,T');        	%二值掩模，压缩DCT系数，只留左上角的10个
mask=[1 1 1 1 0 0 0 0
      1 1 1 0 0 0 0 0
      1 1 0 0 0 0 0 0
      1 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 ]
B2=blkproc(B,[8 8],'P1.*x',mask);        	%只保留DCT变换的10个系数
I2=blkproc(B2,[8 8],'P1*x*P2',T',T) ;      	%重构图像
subplot(2,2,1);
imshow(I);
title('灰度图像');
subplot(2,2,3);
imshow(I2);
title('压缩图像');
