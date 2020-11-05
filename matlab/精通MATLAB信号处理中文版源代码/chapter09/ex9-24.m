clear all
A= imread('rice.png');  	       %读取图像
subplot(121),
imshow(A)
title('原始图像');
A=double(A);
[m,n]=size(A);
for k=1:n                  	%对图像进行沃尔什-哈达玛变换
    wht(:,k)=hadamard(m)*A(:,k)/m;
end
for j=1:m
    wh(:,j)=hadamard(n)*wht(j,:)'/n;
end
wh=wh';
subplot(122),
imshow(wh)
title('沃尔什-哈达玛变换');
