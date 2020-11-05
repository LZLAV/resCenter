I = imread('tire.tif');
[f1,f2] = freqspace(size(I),'meshgrid'); %生成频率序列矩阵
Hd = ones(size(I));   
r = sqrt(f1.^2 + f2.^2); 
Hd(r>0.1) = 0;   %构造滤波器
Y=fft2(double(I));   
Y=fftshift(Y);   
Ya=Y.*Hd;   %滤波
Ya=ifftshift(Ya);   
Ia01=ifft2(Ya);
Hd(r>0.2) = 0;   %构造滤波器
Y=fft2(double(I));  
Y=fftshift(Y);   
Ya=Y.*Hd;   
Ya=ifftshift(Ya);  
Ia02=ifft2(Ya);
Hd(r>0.5) = 0;   %构造滤波器
Y=fft2(double(I));  
Y=fftshift(Y); 
Ya=Y.*Hd;   
Ya=ifftshift(Ya);  
Ia05=ifft2(Ya);
subplot(2,2,1),
imshow(I),
title('原始图像')
subplot(2,2,2),
imshow(uint8(Ia01)),
title('r为0.1时')
subplot(2,2,3),
imshow(uint8(Ia02)),
title('r为0.2时')
subplot(2,2,4),
imshow(uint8(Ia05)),
title('r为0.5时')
