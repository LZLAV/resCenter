clear all;
[Z,P,K]=buttap(20)
[num,den]=zp2tf(Z,P,K);
freqs(num,den);
