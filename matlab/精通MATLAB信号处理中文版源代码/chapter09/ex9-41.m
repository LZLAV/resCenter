clear all;
[I,map]=imread('canoe.tif');     %¶ÁÈ¡Í¼Ïñ
noisy=imnoise(I,'gaussian',0.02);
[M,N]=size(I);
F=fft2(noisy);
fftshift(F);
Dcut=100;
D0=150;
D1=250;
for u=1:M
    for v=1:N
        D(u,v)=sqrt(u^2+v^2);
        BUTTERH(u,v)=1/(1+(sqrt(2)-1)*(D(u,v)/Dcut)^2);
        EXPOTH(u,v)=exp(log(1/sqrt(2))*(D(u,v)/Dcut)^2);
        if D(u,v)<D0
            THPFH(u,v)=1;
        elseif D(u,v)<=D1
            THPEH(u,v)=(D(u,v)-D1)/(D0-D1);
        else
            THPFH(u,v)=0;
        end
    end
end
BUTTERG=BUTTERH.*F;
B=ifft2(BUTTERG);
EXPOTG=EXPOTH.*F;
E=ifft2(EXPOTG);
THPFG=THPFH.*F;
T=ifft2(THPFG);
figure, subplot(221);imshow(noisy); 
title('¼ÓÔëÉùÍ¼Ïñ')%ÏÔÊ¾Í¼Ïñ
subplot(222);imshow(B,map);
 title('°ÍÌØÎÖË¹µÍÍ¨ÂË²¨')
subplot(223);imshow(E,map) ;
title('Ö¸ÊýµÍÍ¨ÂË²¨')
subplot(224);imshow(T,map);
 title('ÌÝÐÎµÍÍ¨ÂË²¨')
