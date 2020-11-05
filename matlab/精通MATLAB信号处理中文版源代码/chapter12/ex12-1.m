T=10e-6;        
B=30e6;                         
K=B/T;                          
Fs=2*B;Ts=1/Fs;                 
N=T/Ts;
t=linspace(-T/2,T/2,N);
St=exp(j*pi*K*t.^2);                 
subplot(211)
plot(t*1e6,St);
xlabel('Time in u sec');
title('线性调频信号');
grid on;axis tight;
subplot(212)
freq=linspace(-Fs/2,Fs/2,N);
plot(freq*1e-6,fftshift(abs(fft(St))));
xlabel('Frequency in MHz');
title('线性调频信号的幅频特性');
grid on;axis tight;
