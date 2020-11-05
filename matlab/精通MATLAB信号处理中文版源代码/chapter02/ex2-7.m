clear
n=0:20;
a1=1.6;a2=-1.6;a3=0.9;a4=-0.9;
x1=a1.^n;
x2=a2.^n;
x3=a3.^n;
x4=a4.^n;
subplot(221)
stem(n,x1,'fill');
grid on;
xlabel('n'); ylabel('h(n)');
title('x(n)=1.6^{n}')
subplot(222)
stem(n,x2,'fill');
grid on
xlabel('n'); ylabel('h(n)');
title('x(n)=(-1.6)^{n}')
subplot(223)
stem(n,x3,'fill');
grid on
xlabel('n') ; ylabel('h(n)');
title('x(n)=0.9^{n}')
subplot(224)
stem(n,x4,'fill');
grid on
xlabel('n'); ylabel('h(n)');
title('x(n)=(-0.9)^{n}')
