clear all;
t=0:0.002:4;
sys=tf([1,32],[1,4,64]);
h=impulse(sys,t);   %冲激响应
g=step(sys,t);      %阶跃响应
subplot(2,1,1);plot(t,h);
grid on;
xlabel('时间/s');ylabel('h(t)');
title('冲激响应');
subplot(2,1,2);plot(t,g);
grid on;
xlabel('时间/s');ylabel('g(t)');
title('阶跃响应');
