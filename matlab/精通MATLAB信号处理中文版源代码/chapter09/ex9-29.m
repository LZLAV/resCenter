%对多波段进行预处理。
function X=row(varargin);
ori=varargin{1};
[m,n]=size(ori(:,:,1));
iii=size(varargin{1});
band=iii(3);
if band==1
        error('Open file wrong!');
else
        X=zeros(band,m*n);
        for i=1:band
            a=ori(:,:,i);
            a=a';
            a=a(:)';
            for j=1:m*n
                X(i,j)=a(1,j);
            end
        end
end
X;
%计算均值等。
function [Mx,Cx,L,A]=PCA(a)
[m,n]=size(a);
Mx=zeros(m,1);
Nx=zeros(m,1);
Cx=zeros(m,m);
Cx=0;
for i=1:m
    for j=1:n
        Mx(i,1)=Mx(i,1)+a(i,j);
    end
end
Mx=Mx/n;
for j=1:n
    for i=1:m
        Nx(i,1)=a(i,j);
    end
    Cx=Cx+(Nx-Mx)*((Nx-Mx)');
end
Cx=Cx/n;
[A,L]=eig(Cx);
[A,L]=taxis(A,L);

%进行排序
function [A,L]=taxis(A,L)
[m,n]=size(L);
for i=1:m-1
        for j=i+1:m
            if L(i,i)<L(j,j)
                temp=L(i,i);
                L(i,i)=L(j,j);
                L(j,j)=temp;
                for j0=1:m
                    temp0=A(j0,i);
                    A(j0,i)=A(j0,j);
                    A(j0,j)=temp0;
                end
            end  
        end
end
L=L;
A=A;
主程序为：
f=imread('football.jpg');
subplot(2,2,1),imshow(f);
title('原始图像')
X=row(f); 
[Mx,Cx,L,A]=PCA(X);
dlmwrite('pcaL.txt',L,'precision','%.6f','newline','pc');
dlmwrite('pcaA.txt',A,'precision','%.6f','newline','pc');
B=inv(A);
r_m=double(f(:,:,1));
g_m=double(f(:,:,2));
b_m=double(f(:,:,3));
%%%得到第一主成分、第二主成分、第三主成分
KLTT1=A(1,1)*r_m+A(2,1)*g_m+A(3,1)*b_m; %得到第一主成分
KLTT1=uint8(KLTT1);
KLTT2=A(1,2)*r_m+A(2,2)*g_m+A(3,2)*b_m; %第二主成分
KLTT2=uint8(KLTT2);
KLTT3=A(1,3)*r_m+A(2,3)*g_m+A(3,3)*b_m; %得到第三主成分
KLTT3=uint8(KLTT3);
subplot(2,2,2);imshow(KLTT1,[]);
title('第一主成分')
subplot(2,2,3);imshow(KLTT2,[]);
title('第二主成分')
subplot(2,2,4);imshow(KLTT3,[]);
title('第三主成分')
