function y = parfiltr(C,B,A,x)
% IIR 滤波器的并型实现
% y = parfiltr(C,B,A,x)
% y 为输出
% C 为当B的长度等于A 的长度时多项式的部分
% B = 包含各因子系数 bk 的K行二维实系数矩阵
% A = 包含各因子系数 ak 的K行三维实系数矩阵
% x 为输入
[K,L] = size(B);
N = length(x);
w = zeros(K+1,N);
w(1,:) = filter(C,1,x);
for i=1:1:K
    w(i+1,:) = filter(B(i,:),A(i,:),x);
end
y = sum(w);