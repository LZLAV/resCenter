syms t;
f=sym('sin(t-2)+t');
f1=subs(f,t,-t)
g=1/2*(f+f1);
h=1/2*(f-f1);
z=g+h;
subplot(311);ezplot(g,[-8,8]);title('偶分量');
subplot(312);ezplot(h,[-8,8]);title('奇分量');
subplot(313);ezplot(z,[-8,8]);title('原信号');
