function [b,a] = par2dir(C,B,A)
% 并联模型到直接型的转换
% [b,a] = par2dir(C,B,A)
% C 为当 b 的长度大于 a 时的多项式部分
% B 为包含 bk 的 K乘 二维实系数矩阵
% A 为包含各 ak 的K 乘三维实系数矩阵
% b 为直接型分子多项式系数
% a 为直接型分母多项式系数
[K,L] = size(A);
R = [];
P = [];
for i=1:1:K
    [r,p,k] = residuez(B(i,:),A(i,:));
    R = [R;r];
    P = [P;p];
end
[b,a] = residuez(R,P,C);
b = b(:);
a = a(:);