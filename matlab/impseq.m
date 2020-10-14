function [x,n] = impseq(n0,n1,n2)
% Generate x(n) = delta(n-n0);n1<=n<=n2;
n = n1:0.01:n2;
x = [(n-n0) ==0];   % 其中 n0 为 delta =1 处横坐标
end