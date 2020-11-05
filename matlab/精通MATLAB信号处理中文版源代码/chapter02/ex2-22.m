tn=0:50;
N=length(tn);
x=rand(1,N);
subplot(1,2,1),plot(tn,x,'k');
ylabel('x(t)');
subplot(1,2,2),stem(tn,x,'filled','k');
ylabel('x(n)');
