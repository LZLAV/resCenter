w1=2*500*tan(2*pi*90/(2*400));
w2=2*500*tan(2*pi*110/(2*400));
wr=2*500*tan(2*pi*120/(2*400));
[N,wn]=buttord([w1 w2],[1 wr],3,10,'s');
[B,A]=butter(N,wn,'s');
[num,den]=bilinear(B,A,400);
[h,w]=freqz(num,den);
f=w/pi*200;
plot(f,20*log10(abs(h)));
axis([40,160,-30,10]);
grid;
xlabel('ÆµÂÊ/kHz')
ylabel('·ù¶È/dB')
