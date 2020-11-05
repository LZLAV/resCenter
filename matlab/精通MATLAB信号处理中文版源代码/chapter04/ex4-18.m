clear all;
n=0:0.02:4;  %频率点
for i=1:4   %取4种滤波器
    switch i
        case 1, N=1;
        case 2; N=3;
        case 3; N=5;
        case 4; N=7;
    end
    Rs=20; 
    [z,p,k]=cheb2ap(N,Rs);  %设计Chebyshev II型模拟原型滤波器
    [b,a]=zp2tf(z,p,k); %将零点极点增益形式转换为传递函数形式
    [H,w]=freqs(b,a,n); %按n指定的频率点给出频率响应
    magH2=(abs(H)).^2;  %给出传递函数幅度平方
    posplot=['2,2',num2str(i)];  %将数字i转换为字符串,与'2,2'合并并赋给posplot
    subplot(posplot);
    plot(w,magH2);
   title(['N=' num2str(N)]);  %将数字N转换为字符串'N='合并作为标题
   xlabel('w/wc');  %显示横坐标
   ylabel('切比雪夫II型 |H(jw)|^2');  % 显示纵坐标
   grid on;
end
