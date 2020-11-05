x=0:0.01*pi:4*pi;
y1=2*sin(x);
y2=cos(x);
y3= sin (2*x).*cos(x);
plot(x,[y1;y2;y3])
axis([0 4*pi -2 2.5])
set(gca,'XTick',[0 pi 2*pi],'XTickLabel',{'0','pi','2pi'})
legend('2* cos (x)',' sin (x)','cos (2x) sin (x)')
