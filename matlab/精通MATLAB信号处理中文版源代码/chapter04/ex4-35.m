clear all;
Wp = [60 200]/500; Ws = [50 250]/500;
Rp = 3; Rs = 40;
[n,Wn] = cheb1ord (Wp,Ws,Rp,Rs)
[b,a] = butter(n,Wn);
freqz(b,a,128,1000);
title('n=7 ButterworthÂË²¨Æ÷');
