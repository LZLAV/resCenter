x=0:0.2:8
y1=0.2+sin(-2*x)
y2=sin(x.^0.5)
plot(x,y1,'g-+',x,y2,'r--d')
