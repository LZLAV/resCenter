clear all;
eq = 'D2y+3*Dy+2*y=0';
cond = 'y(0)= 1,Dy(0)=2';
yzi = dsolve(eq,cond);
yzi = simplify(yzi)