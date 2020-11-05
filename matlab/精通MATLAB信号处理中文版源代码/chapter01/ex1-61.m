x=0:pi/100:3*pi;
y=cos(x);
line([0,3*pi],[0,0]) 
hold on;
plot(x,y)
axis([0 3*pi -2 2])
axis(`xy`) 
