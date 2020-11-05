x=-7:0.5:7;
y=x;
[X,Y]=meshgrid(x,y);
Q=sqrt(X.^2+Y.^2)+eps;
Z=2*cos(Q)./Q;
surf(X,Y,Z)
grid on
axis([-10 10 -10 10 -0.5 1.5])
shading faceted
