clear;

t = linspace(1e-3,100e-3,10);
xn = sin(100*2*pi*t);
N = length(xn);
WNnk = dftmtx(N);
Xk = xn * WNnk;
y = fft(xn);
subplot(2,1,1);
stem(1:N,xn);
subplot(2,1,2);
stem(1:N,abs(Xk));
subplot(2,2,1)
stem(1:N,real(y));