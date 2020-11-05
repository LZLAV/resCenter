x=0:pi/100:2*pi;
y=cos(x);
line([0,2*pi],[0,0]) 
hold on;
plot(x,y)
axis([0 2*pi -1 1])
