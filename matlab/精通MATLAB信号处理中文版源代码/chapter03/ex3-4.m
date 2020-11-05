clear all;close all;clc;
w=(-4*pi:0.001:4*pi)+eps;
X=1./(1-0.6*exp(-j*w));
subplot(211),
plot(w/pi,abs(X),'LineWidth',2);
xlabel('\omega/\pi');
ylabel('|H(e^j^\omega)|');
title('∑˘∆µœÏ”¶');
axis([-3.2 3.2 0.5 2.2]);
grid;
subplot(212),
plot(w/pi,angle(X),'LineWidth',2);
xlabel('\omega/\pi');
ylabel('\theta(\omega)');
title('œ‡∆µœÏ”¶');
axis([-3.2 3.2 -0.6 0.6]);grid;
set(gcf,'color','w');
