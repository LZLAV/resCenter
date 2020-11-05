clear all;
M=20;
alpha=(M-1)/2;
magHk=[1 1 1 0.5 zeros(1,13) 0.5 1 1];
k1=0:10;
k2=11:M-1;
angHk=[-alpha*2*pi/M*k1,alpha*2*pi/M*(M-k2)];
H=magHk.*exp(j*angHk);
h=real(ifft(H,M));
[C,B,A]=dir2fs(h)
