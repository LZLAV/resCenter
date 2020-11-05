figure
subplot(221)
x=-2.9:0.2:2.9           %ÌõĞÎÍ¼
bar(x,exp(-x.^2))
subplot(222)
x=0:0.1:4                %Õë×´Í¼
y=(x.^0.8).*exp(-x)
stem(x,y)
subplot(223)
x=0:0.25:10              %½×ÌİÍ¼
stairs(x,sin(2*x)+sin(x))
subplot(224)
x=[43 78 88 43 21]         %±ıÍ¼
pie(x)
