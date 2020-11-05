close all
clear
[X,Y] = meshgrid(-2:.4:2);
Z = 2*X.^2-3*Y.^2;
subplot(2,2,1)
plot3(X,Y,Z)
subplot(2,2,2)
mesh(X,Y,Z)
subplot(2,2,3)
meshc(X,Y,Z)
subplot(2,2,4)
meshz(X,Y,Z)
