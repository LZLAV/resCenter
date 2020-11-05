clear
ts=0;te=5;dt=0.01;
sys=tf([1],[1 2 200]);
t=ts:dt:te;
f=10*cos(2*pi*t);
y=lsim(sys,f,t);
plot(t,y);
xlabel('t(s)');ylabel('y(t)');
title('Áã×´Ì¬ÏìÓ¦')
grid on; 
