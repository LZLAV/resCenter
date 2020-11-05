I = imread('onion.png');
[f1,f2] =freqspace(size(I),'meshgrid');
D=0.4;     %截止频率
n=1;
Hd = ones(size(I)); 
r = sqrt(f1.^2 + f2.^2);
for i=1:size(I,1)
    for j=1:size(I,2)
        t=r(i,j)/(D*D);
        Hd(i,j) = t^n/(t^n+1);%构造滤波函数
    end
end
B=fft2(double(I)); 
B=fftshift(B);
Ba=B.*Hd;
Ba=ifftshift(Ba);
Ia1=ifft2(Ba);
n=5;    
Hd = ones(size(I)); 
r = sqrt(f1.^2 + f2.^2);
for i=1:size(I,1)
    for j=1:size(I,2)
        t=r(i,j)/(D*D);
        Hd(i,j) = t^n/(t^n+1);%构造滤波函数
    end
end
B=fft2(double(I)); 
B=fftshift(B);%
Ba=B.*Hd;%
Ba=ifftshift(Ba);%
Ia2=ifft2(Ba);%
n=15;    
Hd = ones(size(I)); 
r = sqrt(f1.^2 + f2.^2);
for i=1:size(I,1)
    for j=1:size(I,2)
        t=r(i,j)/(D*D);
        Hd(i,j) = t^n/(t^n+1);%构造滤波函数
    end
end
B=fft2(double(I)); 
B=fftshift(B);%
Ba=B.*Hd;%
Ba=ifftshift(Ba);%
Ia6=ifft2(Ba);%
%显示图像
subplot(2,2,1),
imshow(I),
title('原始图像');
subplot(2,2,2),
imshow(uint8(Ia1)),
title('n为1时');
subplot(2,2,3),
imshow(uint8(Ia2)),
title('n为5时');
subplot(2,2,4),
imshow(uint8(Ia6)),
title('n为15时');
