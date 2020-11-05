t=-3:0.001:3;
ft=tripuls(t,4,0.5);
subplot(2,1,1)
plot(t,ft)
ft=tripuls(3*t,4,0.5);
subplot(2,1,2)
plot(t,ft)
