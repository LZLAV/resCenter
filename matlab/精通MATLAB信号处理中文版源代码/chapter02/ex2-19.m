clear
t=0:0.01:2;
y=chirp(t,0,1,120);
plot(t,y);
axis([0,1,0,1])
ylabel('x(t)');
xlabel('t');
grid on;
