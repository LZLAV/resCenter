clear all;
n1=0:3;
x1=[3 0.6 0.8 1];
subplot(311);
stem(n1,x1)
axis([-1 8 0 2.1] )
n2=0:7;
x2=[ 0 0.2 0.2 0.3 0.5 0.5 0.6 0.9];
subplot(312);
stem(n2,x2)
axis([-1 8 0 0.8] )
n=0:7;
x1=[x1 zeros(1,8-length(n1))];
x2=[ zeros(1,8-length(n2)),x2];
x=x1.*x2;
subplot(313);
stem(n,x)
axis([-1 8 0 0.35])
