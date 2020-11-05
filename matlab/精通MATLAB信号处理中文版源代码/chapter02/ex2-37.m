clear
nx=-1:5; 
nh=-2:10; 
x=uDT(nx)-uDT(nx-4);
h=0.9.^nh.*(uDT(nh)-uDT(nh-9));
y=conv(x,h);
ny1=nx(1)+nh(1);          
ny=ny1+(0:(length(nx)+length(nh)-2));
subplot(131)
stem(nx,x,'fill'),grid on
xlabel('n'),ylabel('x(n)');
title('x(n)')
axis([-4 16 0 3])
subplot(132)
stem(nh,h','fill'),grid on
xlabel('n');ylabel('h(n)');
title('h(n)')
axis([-4 16 0 3])
subplot(133)
stem(ny,y,'fill'),grid on
xlabel('n');ylabel('y(n)');
title('y(n)=x(n)*h(n)')
axis([-4 16 0 3])
