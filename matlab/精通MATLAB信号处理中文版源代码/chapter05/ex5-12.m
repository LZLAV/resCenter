N=49;n=1:N;
wdhn=hanning(N);	
figure(3);
stem(n,wdhn,'.');
grid on
axis([0,N,0,1.1]);
title(¡¯50µãººÄþ´°¡¯);
ylabel('W(n)');
xlabel('n');
title(¡¯50µãººÄþ´°¡¯);
