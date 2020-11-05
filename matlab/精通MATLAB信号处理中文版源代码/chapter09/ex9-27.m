fid1=fopen('mydata1.dat','r');
fid2=fopen('mydata2.dat','r');
fid3=fopen('mydata3.dat','r');
fid4=fopen('mydata4.dat','r');
I11=fread(fid1,cont1,'int8');
I12=fread(fid2,cont2,'int8');
I13=fread(fid3,cont3,'int8');
I14=fread(fid4,cont4,'int8');

tt=1;
for l=1:n
    for k=1:m
        I1(k,l)=I11(tt);
        tt=tt+1;
    end
end

tt=1;
for l=1:n
    for k=1:m
        I2(k,l)=I12(tt);
        tt=tt+1;
      end
end

tt=1;
for l=1:n
    for k=1:m
        I3(k,l)=I13(tt);
        tt=tt+1;
    end
end

tt=1;
for l=1:n
    for k=1:m
        I4(k,l)=I14(tt);
        tt=tt+1;
    end
end

I1=double(I1);
I2=double(I2);
I3=double(I3);
I4=double(I4);

A1=ones(m,n);
A1(1:m,1)=I1(1:m,1);
A1(1,1:n)=I1(1,1:n);
A1(1:m,n)=I1(1:m,n);
A1(m,1:n)=I1(m,1:n);

A2=ones(m,n);
A2(1:m,1)=I2(1:m,1);
A2(1,1:n)=I2(1,1:n);
A2(1:m,n)=I2(1:m,n);
A2(m,1:n)=I2(m,1:n);

A3=ones(m,n);
A3(1:m,1)=I3(1:m,1);
A3(1,1:n)=I3(1,1:n);
A3(1:m,n)=I3(1:m,n);
A3(m,1:n)=I3(m,1:n);

A4=ones(m,n);
A4(1:m,1)=I4(1:m,1);
A4(1,1:n)=I4(1,1:n);
A4(1:m,n)=I4(1:m,n);
A4(m,1:n)=I4(m,1:n);

for k=2:m-1	%一阶解码
    for l=2:n-1
        A1(k,l)=I1(k,l)+A1(k,l-1);
    end
end
cc1=fclose(fid1);
A1=uint8(A1);

for k=2:m-1	%二阶解码
    for l=2:n-1
        A2(k,l)=I2(k,l)+(A2(k,l-1)/2+A2(k-1,l)/2);
    end
end
cc2=fclose(fid2);
A2=uint8(A2);

for k=2:m-1	%三阶解码
    for l=2:n-1
        A3(k,l)=I3(k,l)+(A3(k,l-1)*(4/7)+A3(k-1,l)*(2/7)+A3(k-1,l-1)*(1/7));
    end
end
cc3=fclose(fid3);
A3=uint8(A3);

for k=2:m-1	%四阶解码
    for l=2:n-1
        A4(k,l)=I4(k,l)+(A4(k,l-1)/2+A4(k-1,l)/4+A4(k-1,l-1)/8+A4(k-1,l+1)/8);
    end
 end
cc4=fclose(fid4);
A4=uint8(A4);

figure(2) 	%分区画图
subplot(2,3,1);
imshow(I03);
axis off
box off
title('原始图像');

subplot(2,3,2);
imshow(I02);
axis off
box off
title('灰度图像');

subplot(2,3,3);
imshow(A1);
axis off
box off
title('一阶解码');

subplot(2,3,4);
imshow(A2);
axis off
box off
title('二阶解码');

subplot(2,3,5);
imshow(A3);
axis off
box off
title('三阶解码');

subplot(2,3,6);
imshow(A4);
axis off
box off
title('四阶解码');
