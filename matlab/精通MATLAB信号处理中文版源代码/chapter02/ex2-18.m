syms t f1;
f1=2*heaviside(t)-heaviside(t-1); 
t=-1:0.01:2; 
subplot(121);
ezplot(f1,t);
title('原函数')
grid on;
f=int(f1,'t'); 
subplot(122);
ezplot(f,t)
grid on
title('微分函数')
ylabel('x(t)');
