x=linspace(0,2*pi,100)
subplot(2,2,1),plot(x,sin(x))
xlabel('x'),ylabel('y'),title('sin(x)')
subplot(222),plot(x,cos(x))
xlabel('x'),ylabel('y'),title('cos(x)')
subplot(223),plot(x,exp(x))
xlabel('x'),ylabel('y'),title('exp(x)')
subplot(2,2,4),plot(x,exp(-x))
xlabel('x'),ylabel('y'),title('exp(-x)')
