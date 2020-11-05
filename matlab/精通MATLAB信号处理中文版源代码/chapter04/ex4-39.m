[B,A]=butter(3,2*pi*1000,'s');
[num1,den1]=impinvar(B,A,4000);
[h1,w]=freqz(num1,den1);
[B,A]=butter(3,2/0.00025,'s');
[num2,den2]=bilinear(B,A,4000);
[h2,w]=freqz(num2,den2);
f=w/pi*2000;
plot(f,abs(h1),'-.',f,abs(h2),'-');
grid;
xlabel('ÆµÂÊ/Hz ')
ylabel('·ùÖµ')
