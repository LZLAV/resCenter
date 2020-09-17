function [X,freq] = centeredFFT(x,Fs)
N = length(x);
disp(N);
if mod(N,2) ==0 
    k = -N/2:N/2-1;
else
    k = -(N-1)/2:(N-1)/2;
end
T = N/Fs;
freq = k/T;
X = fft(x);
X = fftshift(X);