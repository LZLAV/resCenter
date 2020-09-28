function y = casfilter(b0,B,A,x)
[K,L] = size(B);
N = length(x);
w = zeros(K+1,N);
w(1,:) = x;
for i=1:1:K
    w(i+1,:) = filter(B(i,:),A(i,:),w(i,:));
end
y = b0 * w(K+1,:);
% IIR 滤波器的级联实现
% y = casfilter(b0,B,A,x);
% y 为输出
% b0 = 增益系数
% B = 包含各因子系数bk 的K行3列矩阵
% A = 包含各因子系数ak 的K行3列矩阵
% x 为输入
