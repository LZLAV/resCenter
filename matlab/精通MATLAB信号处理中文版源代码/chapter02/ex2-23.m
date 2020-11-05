clear
Fs=10000;t=0:1/Fs:1;
x1=sawtooth(2*pi*40*t,0);
x2=sawtooth(2*pi*40*t,1);
subplot(2,1,1);
plot(t,x1);axis([0,0.25,-1,1]);
subplot(2,1,2);
plot(t,x2);axis([0,0.25,-1,1]);
