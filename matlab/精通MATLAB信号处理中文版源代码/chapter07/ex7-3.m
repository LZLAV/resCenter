a=0.78;
sigma=3;
N=500;
u=randn(N,1);
x(1)=sigma*u(1)/sqrt(1-a^2);
for i=2:N
    x(i)=a*x(i-1)+sigma*u(i);
end
plot(x);
xlabel('n');ylabel('x(n)');
