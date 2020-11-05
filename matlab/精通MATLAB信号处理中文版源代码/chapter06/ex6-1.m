L=input('请输入信号长度L=');
N=input('请输入滤波器阶数N=');
%产生w(n),v(n),u(n),s(n)和x(n)
a=0.95;
b1=sqrt(12*(1-a^2))/2;
b2=sqrt(3);
w=random('uniform',-b1,b1,1,L);						%利用random函数产生均匀白噪声
v=random('uniform',-b2,b2,1,L);
u=zeros(1,L);
for i=1:L
  u(i)=1;
end
s=zeros(1,L); 
s(1)=w(1);
for i=2:L,
  s(i)=a*s(i-1)+w(i);
end
  x=zeros(1,L);
  x=s+v;
%绘出s(n)和x(n)的曲线图
set(gcf,'Color',[1,1,1]);
i=L-100:L;
subplot(2,2,1);
plot(i,s(i),i,x(i),'r:');
title('s(n) & x(n)');
legend('s(n)', 'x(n)');
%计算理想滤波器的h(n)
h1=zeros(N:1);
for i=1:N
     h1(i)=0.238*0.724^(i-1)*u(i);
end
%利用公式，计算Rxx和rxs
Rxx=zeros(N,N);
rxs=zeros(N,1);
for i=1:N
     for j=1:N
         m=abs(i-j);
         tmp=0;
         for k=1:(L-m)
             tmp=tmp+x(k)*x(k+m);
         end
         Rxx(i,j)=tmp/(L-m);
     end
end
for m=0:N-1
     tmp=0;
     for i=1: L-m
         tmp=tmp+x(i)*s(m+i);
     end
     rxs(m+1)=tmp/(L-m);
 end
%产生FIR维纳滤波器的h(n)
h2=zeros(N,1);
h2=Rxx^(-1)*rxs;
%绘出理想和维纳滤波器h(n)的曲线图
i=1:N;
subplot(2,2,2);
plot(i,h1(i),i,h2(i),'r:');
title('h(n) & h~(n)');
legend('h(n) ','h~(n)');
%计算Si
Si=zeros(1,L);
Si(1)=x(1);
for i=2:L
Si(i)=0.724*Si(i-1)+0.238*x(i);
end
%绘出Si(n)和s(n)曲线图
 i=L-100:L;
 subplot(2,2,3);
 plot(i,s(i),i,Si(i),'r:');
title('Si(n) & s(n)');
legend('Si(n) ','s(n)');
%计算Sr
Sr=zeros(1,L);
for i=1:L
     tmp=0;
     for j=1:N-1
         if(i-j<=0)
             tmp=tmp;
         else 
             tmp=tmp+h2(j)*x(i-j);
         end
     end
     Sr(i)=tmp;
 end
%绘出Si(n)和s(n)曲线图
i=L-100:L;
subplot(2,2,4);
plot(i,s(i),i,Sr(i),'r:');
title('s(n) & Sr(n)');
legend('s(n) ','Sr(n)');
%计算均方误差Ex,Ei和Er
tmp=0;
 for i=1:L
     tmp=tmp+(x(i)-s(i))^2;
end
Ex=tmp/L,										%打印出Ex
tmp=0;
for i=1:L
     tmp=tmp+(Si(i)-s(i))^2;
end
Ei=tmp/L,
tmp=0;
for i=1:L
      tmp=tmp+(Sr(i)-s(i))^2;
end
Er=tmp/L
