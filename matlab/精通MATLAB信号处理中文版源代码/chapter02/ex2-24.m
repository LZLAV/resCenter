clear
t=-3:0.001:3;
y=rectpuls(t);
subplot(121)
plot(t,y);
axis([-2 2 -1 2]);
grid on;
xlabel('t');
ylabel('w(t)');
y=2.5*rectpuls(t,2);
subplot(122)
plot(t,y);grid on;
axis([-2 2 -1 3]);
grid on;
xlabel('t');
ylabel('w(t)');
