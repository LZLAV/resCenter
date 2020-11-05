clear all;
A=imread('office_4.jpg');
subplot(121);imshow(A);
title('原始图像')
A=double(A);
A_move=zeros(size(A));
H=size(A);
A_x=50;
A_y=50;
A_movesult(A_x+1:H(1),A_y+1:H(2),1:H(3))=A(1:H(1)-A_x,1:H(2)-A_y,1:H(3));
subplot(122);
imshow(uint8(A_movesult));
title('平移后图像')
