N=60; 
L=512;
f1=100;f2=150;fs=600;
ws=2*pi*fs;
t=(0:N-1)*(1/fs);
x=cos(2*pi*f1*t)+0.25*sin (2*pi*f2*t);
wh=boxcar(N)';
x=x.*wh;
subplot(221);stem(t,x);
title('加矩形窗时域图');
xlabel('n');ylabel('h(n)')
grid on
W=fft(x,L);
f=((-L/2:L/2-1)*(2*pi/L)*fs)/(2*pi); 
subplot(222);
plot(f,abs(fftshift(W)))
title('加矩形窗频域图');
xlabel('频率');ylabel('幅度')
grid on
x=cos(2*pi*f1*t)+0.15*cos(2*pi*f2*t); 
wh=hanning(N)';
x=x.*wh;
subplot(223);stem(t,x);
title('加汉宁窗时域图');
xlabel('n');ylabel('h(n)')
grid on
W=fft(x,L);
f=((-L/2:L/2-1)*(2*pi/L)*fs)/(2*pi);
subplot(224);
plot(f,abs(fftshift(W)))
title('加汉宁窗频域图');
xlabel('频率');ylabel('幅度')
grid on
