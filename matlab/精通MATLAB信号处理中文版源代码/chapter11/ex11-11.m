clear all
M=4;   
k=log2(M);   
n=5000;   
%u=0.05;
u1=0.001;
u2=0.0001;
m=500;
%h=[0.05 -0.063 0.088];%-0.126]; -0.25];
h=[1 0.3 -0.3 0.1 -0.1];
L=7; 
mse1_av=zeros(1,n-L+1);
mse2_av=mse1_av;
for j=1:m
      a=randint(1,n,M);     
      a1=pskmod(a,M);
      m1=abs(a1).^4;
      m2=abs(a1).^2;      
      r1=mean(m1);
      r2=mean(m2);     
      R2=r1/r2;
      %R2=sqrt(2%);
     s=filter(h,1,a1);   
     snr=15;  
    x=awgn(s,snr,'measured');
    c1=[0 0 0 1 0 0 0 ];
    c2=c1;
    y=zeros(n-L+1,2);
    for i=1:n-L+1        
        y=x(i+L-1:-1:i);
        z1(i)=c1*y';
        z2(i)=c2*y';
        e1=R2-(abs(z1(i))^2);
        e2=a1(i)-z2(i);
        c1=c1+u1*e1*y*z1(i);
        c2=c2+u2*e2*y;
        mse1(i)=e1^2;
        %u(i)=0.2*(1-exp(-(0.3*abs(e(i)))));        
        mse2(i)=abs(e2)^2;         
    end;
  mse1_av=mse1_av+mse1;
  mse2_av=mse2_av+mse2;
 end;
mse1_av=mse1_av/m;
mse2_av=mse2_av/m;
figure
plot([1:n-L+1],mse1_av,'r',[1:n-L+1],mse2_av,'b')
axis([0,5100,0 2.8]);
scatterplot(a1,1,0,'r*');
hold on
scatterplot(x,1,0,'g*');
hold on
scatterplot(z1(2300:4800),1,0,'r*');
hold off
scatterplot(z2(2300:4800),1,0,'r*');
hold off
