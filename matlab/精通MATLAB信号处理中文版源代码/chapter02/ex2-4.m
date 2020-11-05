clear all
n=40;
x=ones(1,n);
xn=0:n-1;
subplot(211);
stem(xn,x);
grid on     
axis([-1 51 0 1.1]);
title('单位阶跃序列u(n)')
ylabel('u(n)');
xlabel('n');
x=[zeros(1,10),1,ones(1,29)];
subplot(212);
stem(xn,x);
grid on     
axis([-1 51 0 1.1]);
title('单位阶跃序列u(n-10)')
ylabel('u(n-10)');
xlabel('n');
