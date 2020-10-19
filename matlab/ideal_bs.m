function hd = ideal_bs(Wcl,Wch,m)
alpha = (m-1)/2;
n = [0:1:(m-1)];
m = n - alpha +eps;
hd = [sin(m*pi) +sin(Wcl*m) - sin(Wch*m)]/(pi*m);
