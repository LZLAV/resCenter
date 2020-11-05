clear all;
[I,map]=imread('trees.tif');
figure; subplot(121)
imshow(I);
[I2,map] = imcrop(I, map);
subplot(122)
imshow(I2); 
