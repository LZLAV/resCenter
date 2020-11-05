x=[1,3,5,7];
y=[1,1,1,1];
z=conv(x,y)
subplot(131);
stem(0:length(x)-1,x);
ylabel('x[n]'); xlabel('n');
grid on
subplot(132);
stem(0:length(y)-1,y);
ylabel('y[n]'); xlabel('n');
grid on
subplot(133);
stem(0:length(z)-1,z);
ylabel('z[n]'); xlabel('n');
grid on
