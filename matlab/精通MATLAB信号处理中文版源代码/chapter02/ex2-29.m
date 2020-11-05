clear
T=0:1/1E3:1;
D=0:1/4:1;
Y=pulstran(T,D,¡¯rectpuls¡¯,0.1);
subplot(121)
plot(T,Y);
xlabel('t');
ylabel('w(t)');
grid on;axis([0,1,-0.1,1.1]);
T=0:1/1E3:1;
D=0:1/3:1;
Y=pulstran(T,D,¡¯tripuls¡¯,0.2,1);
subplot(122)
plot(T,Y);
xlabel('t');
ylabel('w(t)');
grid on;axis([0,1,-0.1,1.1]);
