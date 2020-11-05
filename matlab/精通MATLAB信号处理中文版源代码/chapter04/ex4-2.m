b=[1,-3,13,27,18];
a=[15,11,2,-4,-2];
N=30;
delta=impz(b,a,N);
x=[ones(1,5),zeros(1,N-5)];
h=filter(b,a,delta); 
y = filter(b,a,x);
subplot(211);stem(h);title('直接型h(n)');
subplot(212);stem(y);title('直接型y(n)');
