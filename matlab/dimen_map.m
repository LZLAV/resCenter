% 二维图形

x = 0:pi/100:2*pi;
y = sin(x);
%plot(x,y,'r--');    %'r--'为线条设定，每个设定可包含表示线条颜色、样式和标记的字符

% 三维图形
[X,Y] = meshgrid(-2:.2:2);     %meshgrid 在此函数的域中创建一组（x,y）点
Z = X.* exp(-X.^2 - Y.^2);
mesh(X,Y,Z);    %surf 函数及其伴随函数 mesh 以三维形式显示曲面图，surf使用颜色显示曲面图的连接线和面；mesh 生成仅以颜色标记连接定义点的线条的线框曲面图


%子图
t = 0:pi/10:2*pi;
[X,Y,Z] = cylinder(4*cos(t));
subplot(2,2,1);
mesh(X);title('X');
subplot(2,2,2);surf(Y);title('Y');  %subplot 函数可以在同一窗口的不同子区域显示多个绘图
subplot(2,2,3);surf(Z);title('Z');  %subplot 的前两个输入表示每行和每列中的绘图数。第三个输入指定绘图是否处于活动状态。
subplot(2,2,4);surf(Z,Y,Z);title('X,Y,Z');