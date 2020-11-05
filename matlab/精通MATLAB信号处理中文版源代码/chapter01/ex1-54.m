x=(0:pi/100:2*pi)';
    y1=2*exp(-0.5*x)*[1,-1];
    y2=2*exp(-0.5*x).*sin(2*pi*x);
    x1=(0:12)/2;
    y3=2*exp(-0.5*x1).*sin(2*pi*x1);
plot(x,y1,'g:',x,y2,'b--',x1,y3,'rp');
