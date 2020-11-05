I=imread('office_4.jpg');         	%¶ÁÈ¡Í¼Ïñ
Len=30;
Theta=45;
PSF=fspecial('motion',Len,Theta);   	%Í¼ÏñµÄÍË»¯
BlurredA=imfilter(I,PSF,'circular','conv');
Wnrl=deconvwnr(BlurredA,PSF);
BlurredD=imfilter(I,PSF,'circ','conv');
INITPSF=ones(size(PSF));
[K DePSF]=deconvblind(BlurredD,INITPSF,30); 	%Ã¤È¥¾í»ýÐÞ¸´Í¼Ïñ
BlurredB=imfilter(I,PSF,'conv');
V=0.02;
Blurred_I_Noisy=imnoise(BlurredB,'gaussian',0,V);
NP=V*prod(size(I));
J=deconvreg(Blurred_I_Noisy,PSF,NP);
BlurredC=imfilter(I,PSF,'symmetric','conv');
V=0.002;
BlurredNoisy=imnoise(BlurredC,'gaussian',0,V);
Luc=deconvlucy(BlurredNoisy,PSF,5);
subplot(2,3,1);
imshow(I);
title('Ô­Ê¼Í¼Ïñ');
subplot(2,3,2);
imshow(PSF);
title('ÔË¶¯Ä£ºýºóÍ¼Ïñ');
subplot(2,3,3);
imshow(Wnrl);
title('Î¬ÄÉÂË²¨ÐÞ¸´Í¼Ïñ');
subplot(2,3,4);
imshow(J);
title('×îÐ¡¶þ³Ë·½ÐÞ¸´Í¼Ïñ');
subplot(2,3,5);
imshow(Luc);
title('Lucy-RichardsonÐÞ¸´Í¼Ïñ');
subplot(2,3,6);
imshow(K);
title('Ã¤È¥¾í»ýÐÞ¸´Í¼Ïñ');
