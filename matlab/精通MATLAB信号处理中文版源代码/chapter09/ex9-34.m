I = imread('gantrycrane.png');
[f1,f2] = freqspace(size(I),'meshgrid');
D=10/size(I,1); %D为10时
Hd = ones(size(I)); 
r = f1.^2 + f2.^2;
for i=1:size(I,1)
    for j=1:size(I,2)
        t=r(i,j)/(D*D);
        Hd(i,j) = exp(-t);
    end
end
E=fft2(double(I));
E=fftshift(E);
Ea=E.*Hd;
Ea=ifftshift(Ea);
Ia10=ifft2(Ea);
D=40/size(I,1); %D为40时
Hd = ones(size(I)); 
r = f1.^2 + f2.^2;
for i=1:size(I,1)
    for j=1:size(I,2)
        t=r(i,j)/(D*D);
        Hd(i,j) = exp(-t);
    end
end
E=fft2(double(I));
E=fftshift(E);
Ea=E.*Hd;
Ea=ifftshift(Ea);
Ia40=ifft2(Ea);
D=100/size(I,1); %D为100时
Hd = ones(size(I)); 
r = f1.^2 + f2.^2;
for i=1:size(I,1)
    for j=1:size(I,2)
        t=r(i,j)/(D*D);
        Hd(i,j) = exp(-t);
    end
end
E=fft2(double(I));
E=fftshift(E);
Ea=E.*Hd;
Ea=ifftshift(Ea);
Ia100=ifft2(Ea);
subplot(2,2,1),
imshow(I),
title('原始图像') %图像显示
subplot(2,2,2),
imshow(uint8(Ia10)),
title('D为10时');
subplot(2,2,3),
imshow(uint8(Ia40)),
title('D为40时');
subplot(2,2,4),
imshow(uint8(Ia100)),
title('D为100时');
