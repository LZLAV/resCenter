clear
i=imread('pout.tif');                    	%读取图像
j=imresize(i,0.5);
j1=imresize(i,2.5);
j2=imresize(i,0.05,'nearest');            	%利用不用的方法对图像进行缩放
j3=imresize(i,0.05,'bilinear');
j4=imresize(i,0.05,'bicubic');
subplot(2,3,1);
imshow(i);
subplot(2,3,2);
imshow(j);
subplot(2,3,3);
imshow(j2);
subplot(2,3,4);
imshow(j1);
subplot(2,3,5);
imshow(j3);
subplot(2,3,6);
imshow(j4);
