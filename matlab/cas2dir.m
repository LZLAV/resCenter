function [b,a] = cas2dir(b0,B,A)
% 级联型到直接型的转换
% a = 直接型分子多项式系数
% b = 直接型分母多项式系数
% b0 = 增益系数
% B = 包含各因子系数 bk 的 K 行3列矩阵
% A = 包含各因子系数 ak 的 K 行3列矩阵
[K,L] = size(B);
b = [1];
a = [1];
for i=1:1:K
    b =conv(b,B(i,:));
    a = conv(a,A(i,:));
end
b = b*b0;