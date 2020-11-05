I1=imread('cameraman.tif'); 	%读入原图像 
subplot(131)
imshow(I1);
title('原始图像'); 	%显示原图像 
I=double(I1); 
[m,n]=size(I); 
mx=max(m,n); 
wal=hadamard(mx); 	%生成hadamard函数 
[f,e]=log2(n); 
I2=dec2bin(0:pow2(0.5,e)-1); 
R=bin2dec(I2(:,e-1:-1:1))+1; 	%将列序进行二进制的倒序排列 
for i=1:m 
    for j=1:n 
        wal1(i,j)=wal(i,R(j)); 
    end 
end                         
J=wal1/256*I*wal1'/256; 	%对图像进行二维walsh变换 
subplot(132)
imshow(J);
title('walsh变换'); 
K=J(1:m/2,1:n/2);  	%截取图像的1/4 
K(m,n)=0;          	%将图像补零至原图像大小 
R=wal1'*K*wal1;      	%对图像进行二维walsh反变换 
subplot(133)
imshow(R,[]);
title('复原图像'); 
cha=I-R; 
%R1=uint8(R); 
%cha1=I1-R1; 
mse=mean(mean(cha.^2));%mse=134.41 
%mse2=mse(abs(cha1)) 
mse1=mse(cha.^2)
