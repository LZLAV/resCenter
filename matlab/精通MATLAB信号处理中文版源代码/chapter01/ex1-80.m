x=-7:0.5:7;
y=x;
[X,Y]=meshgrid(x,y);
Q=sqrt(X.^2+Y.^2)+eps;
Z=cos(Q)./Q;
mesh(X,Y,Z)
grid on
axis([-10 10 -10 10 -1 1 ])
