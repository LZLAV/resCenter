f=6000;nt=3;
N=15;T=1/f; 
dt=T/N; 
n=0:nt*N-1;
tn=n*dt;
x=square(2*f*pi*tn,25)+1;
%产生时域信号,且幅度在0～2之间 
subplot(2,1,1);stairs(tn,x,'k'); 
axis([0 nt*T 1.1*min(x) 1.1*max(x)]);
ylabel('x(t)');
subplot(2,1,2);stem(tn,x,'filled','k'); 
axis([0 nt*T 1.1*min(x) 1.1*max(x)]);
ylabel('x(n)');
