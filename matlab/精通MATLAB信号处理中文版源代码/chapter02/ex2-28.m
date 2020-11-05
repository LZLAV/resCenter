clear
tc = gauspuls('cutoff',60e3,0.6,[],-40); 
t = -tc : 1e-6 : tc; 
yi = gauspuls(t,60e3,0.6); 
plot(t,yi)
xlabel('t');
ylabel('h(t)');
grid on
