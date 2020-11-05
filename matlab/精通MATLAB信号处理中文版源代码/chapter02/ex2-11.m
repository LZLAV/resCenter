clear all; 
nx=-2:5;
x=[2 3 4 5 6 7 8 9];
ny=-fliplr(nx);
y=fliplr(x);
subplot(121),
stem(nx,x,'.');axis([-6 6 -1 9]);grid;
xlabel('n');ylabel('x(n)');title('原序列');
subplot(122),
stem(ny,y,'.');axis([-6 6 -1 9]);grid;
xlabel('n');ylabel('y(n)');title('翻转后的序列');
set(gcf,'color','w');
