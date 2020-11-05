x=-5:5;
y1=randn(size(x));
y2=sin(x);
subplot(2,1,1)
hold
hold	%切换子图1的叠加绘图模式到关闭状态
plot(x,y1,'b')
plot(x,y2,'r')	%新的绘图指令冲掉了原来的绘图结果
title('hold off ')
subplot(2,1,2)
hold on	%打开子图2的叠加绘图模式
plot(x,y1,'b')
plot(x,y2,'r')	%新的绘图结果叠加在原来的图形中
title('hold on ')    
