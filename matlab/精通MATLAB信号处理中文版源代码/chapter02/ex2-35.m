a=[1 -0.35 1.5];
b=[1 1];
t=0:20;
x=(1/2).^t;
y=filter(b,a,x)
subplot(1,2,1)
stem(t,x)
title('输入序列')
grid on
xlabel('n'); ylabel('h(n)');
subplot(1,2,2)
stem(t,y)
xlabel('n'); ylabel('h(n)');
title('响应序列')
grid on
