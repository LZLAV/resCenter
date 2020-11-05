function ljdt(A,B)
p=roots(A);						%求系统极点
q=roots(B);						%求系统零点
p=p';							%将极点列向量转置为行向量
q=q';							%将零点列向量转置为行向量
x=max(abs([p q 1]));				%确定纵坐标范围
x=x+0.1;
y=x;								%确定横坐标范围
clf
hold on
axis([-x x -y y])						%确定坐标轴显示范围
w=0:pi/300:2*pi;
t=exp(i*w);
plot(t)							%画单位园
axis('square')
plot([-x x],[0 0])					%画横坐标轴
plot([0 0],[-y y])					%画纵坐标轴
text(0.1,x,'jIm[z]')
text(y,1/10,'Re[z]')
plot(real(p),imag(p),'x')				%画极点
plot(real(q),imag(q),'o')
title('零极点图')					%标注标题
hold off
运行程序如下：
% 绘制零极点分布图的实现程序
a=[3 -2 0 0 0 1];
b=[2 1];
ljdt(a,b)
p=roots(a)
q=roots(b)
pa=abs(p)
