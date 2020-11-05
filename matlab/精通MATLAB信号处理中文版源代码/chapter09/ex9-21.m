f = zeros(60,60);
f(10:48,26:34) = 1;%生成矩形
F0 = fft2(f); 
F2 = log(abs(F0));
F = fft2(f,256,256); 
F1 = fftshift(F); 
figure;
subplot(221);
imshow(f,'InitialMagnification','fit');%以合适窗口大小显示f
subplot(222);
imshow(F2,[-1 5],'InitialMagnification','fit'); %确定像素值的显示范围
subplot(223);
imshow(log(abs(F)),[-1 5]); %对数显示补零变换后的图像
subplot(224);
imshow(log(abs(F1)),[-1 5]); %对数显示频移后的图像
