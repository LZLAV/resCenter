w1=85/500;
w2=125/500;
[B,A]=butter(1,[w1, w2],'stop');
[h,w]=freqz(B,A);
f=w/pi*500;
plot(f,20*log10(abs(h)));
axis([50,150,-30,10]);
grid;
xlabel('ÆµÂÊ/Hz')
ylabel('·ù¶È/dB')
