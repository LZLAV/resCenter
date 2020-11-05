clc
clear
close all;
I03=imread('onion.png');
I02=rgb2gray(I03); 	%把RGB图像转化为灰度图像
I=double(I02);
fid1=fopen('mydata1.dat','w');
fid2=fopen('mydata2.dat','w');
fid3=fopen('mydata3.dat','w');
fid4=fopen('mydata4.dat','w');
[m,n]=size(I);
A1=ones(m,n); 	%对预测信号将边缘锁定
A1(1:m,1)=I(1:m,1);
A1(1,1:n)=I(1,1:n);
A1(1:m,n)=I(1:m,n);
A1(m,1:n)=I(m,1:n);

A2=ones(m,n);
A2(1:m,1)=I(1:m,1);
A2(1,1:n)=I(1,1:n);
A2(1:m,n)=I(1:m,n);
A2(m,1:n)=I(m,1:n);

A3=ones(m,n);
A3(1:m,1)=I(1:m,1);
A3(1,1:n)=I(1,1:n);
A3(1:m,n)=I(1:m,n);
A3(m,1:n)=I(m,1:n);

A4=ones(m,n);
A4(1:m,1)=I(1:m,1);
A4(1,1:n)=I(1,1:n);
A4(1:m,n)=I(1:m,n);
A4(m,1:n)=I(m,1:n);

for k=2:m-1	%一阶DPCM编码
    for l=2:n-1
        A1(k,l)=I(k,l)-I(k,l-1);
    end
end
A1=round(A1);
cont1=fwrite(fid1,A1,'int8');
cc1=fclose(fid1);

for k=2:m-1	%二阶DPCM编码
    for l=2:n-1
        A2(k,l)=I(k,l)-(I(k,l-1)/2+I(k-1,l)/2);
    end
end
A2=round(A2);
cont2=fwrite(fid2,A2,'int8');
cc2=fclose(fid2);

for k=2:m-1	%三阶DPCM编码
    for l=2:n-1
        A3(k,l)=I(k,l)-(I(k,l-1)*(4/7)+I(k-1,l)*(2/7)+I(k-1,l-1)*(1/7));
    end
end
A3=round(A3);
cont3=fwrite(fid3,A3,'int8');
cc3=fclose(fid3);

for k=2:m-1	%四阶DPCM编码
    for l=2:n-1
        A4(k,l)=I(k,l)-(I(k,l-1)/2+I(k-1,l)/4+I(k-1,l-1)/8+I(k-1,l+1)/8);
    end
end
A4=round(A4);
cont4=fwrite(fid4,A4,'int8');
cc4=fclose(fid4);
figure(1)
subplot(2,3,1);
imshow(I03);
axis off	%隐藏坐标轴和边框
box off
title('原始图像');

subplot(2,3,2);
imshow(I02);
axis off
box off
title('灰度图像');

subplot(2,3,3);
imshow(A1);
axis off
box off
title('一阶');

subplot(2,3,4);
imshow(A2);
axis off
box off
title('二阶');

subplot(2,3,5);
imshow(A3);
axis off
box off
title('三阶');

subplot(2,3,6);
imshow(A4);
axis off
box off
title('四阶');
