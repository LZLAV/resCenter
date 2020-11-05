function kalman1(L,Ak,Ck,Bk,Wk,Vk,Rw,Rv)
w=sqrt(Rw)*randn(1,L);					% w为均值零方差为Rw斯白噪声   
v=sqrt(Rv)*randn(1,L);					% v为均值零方差为Rv高斯白噪声
x0=sqrt(10^(-12))*randn(1,L);
for i=1:L
    u(i)=1;
end
x(1)=w(1);							%给x(1)赋初值.
for i=2:L								%递推求出x(k).
    x(i)=Ak*x(i-1)+Bk*u(i-1)+Wk*w(i-1);
end
yk=Ck*x+Vk*v; 
yik=Ck*x;
n=1:L;
subplot(2,2,1);
plot(n,yk,n,yik,'r:');
legend('yk','yik',1)
Qk=Wk*Wk'*Rw;
Rk=Vk*Vk'*Rv;
P(1)=var(x0);
%P(1)=10;
%P(1)=10^(-12);
P1(1)=Ak*P(1)*Ak'+Qk;
xg(1)=0;
for k=2:L
    P1(k)=Ak*P(k-1)*Ak'+Qk; 
    H(k)=P1(k)*Ck'*inv(Ck*P1(k)*Ck'+Rk);
    I=eye(size(H(k)));
    P(k)=(I-H(k)*Ck)*P1(k);
    xg(k)=Ak*xg(k-1)+H(k)*(yk(k)-Ck*Ak*xg(k-1))+Bk*u(k-1);   
    yg(k)=Ck*xg(k);                                
end
subplot(2,2,2);
plot(n,P(n),n,H(n),'r:')
legend('P(n)','H(n)',4)
subplot(2,2,3);
plot(n,x(n),n,xg(n),'r:')
legend('x(n)','估计xg(n)',1)
subplot(2,2,4);
plot(n,yik(n),n,yg(n),'r:')
legend('估计yg(n)','yik(n)',1)
set(gcf,'Color',[1,1,1]);
对变量进行赋值语句如下：
kalman1(100,0.85,1,0,1,1,0.0875,0.1)
