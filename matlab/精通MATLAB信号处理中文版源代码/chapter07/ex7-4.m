a=0.78;
sigma=3;
N=200;
u=randn(N,1);
x(1)=sigma*u(1)/sqrt(1-a^2);
for i=2:N
    x(i)=a*x(i-1)+sigma*u(i);
end
[f,xi] = ksdensity(x); 
plot(xi,f); 
xlabel('x');
ylabel('f(x)');
axis([-15 15 0 0.13]);
