clear
t = (1:12)';
x= randn(size(t));
ts = linspace(-10,10,500)';
y = sinc(ts(:,ones(size(t))) - t(:,ones(size(ts)))')*x;
plot(t,x,'o',ts,y)
ylabel('x(n)');
xlabel('n');
grid on;
