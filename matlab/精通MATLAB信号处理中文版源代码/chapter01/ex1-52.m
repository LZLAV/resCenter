clear all;          
%准备数据
x=0:0.01:3*pi;
y1=sin(x);
y2=sin(2*x);
y3=sin(3*x);
%设置当前绘图区
figure;
%绘图
plot(x,y1,x,y2,x,y3);
%设置坐标轴和网格线属性
axis([0 8 -2 2]);
grid on;
%标注图形
xlabel('x');
ylabel('y');
title('演示绘图基本步骤')
legend('sin(x)','sin(2x)','sin(3x)')
legend('sin(x)','sin(2x)','sin(3x)')
