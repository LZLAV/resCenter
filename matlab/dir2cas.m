function [b0,B,A] = dir2cas(b,a)
% 变直接形式为级联形式
% [b0,B,A] = dir2cas(b,a)
% b0 = 增益系数
% B = 包含各因子系数 bk 的K行3列矩阵
% A = 包含各因子系数 ak 的K行3列矩阵
% b = 直接型分子多项式系数
% a = 直接型分母多项式系数
b0 = b(1);b = b/b0;
a0 = a(1);a = a/a0;
b0 = b0/a0;
% 将分子、分母多项式系数的长度补齐进行计算
M = length(b);
N = length(a);
if M>N
    b = [b zeros(1,N-M)];
elseif M>N
    a = [a zeros(1,M-N)];
    N = M;
else
    NM = 0;
end

% 级联型系数矩阵初始化
K = floor(N/2);B = zeros(K,3);A = zeros(K,3);
if K*2 == N
    b=[b 0];
    a =[a 0];
end
 % 根据多项式系数利用函数 roots 求出所有的根
 % 利用函数 cplxpair 进行按实部从小到大的成对排序
 broots = cplxpair(roots(b));
 aroots = cplxpair(roots(a));
 % 取出复共轭对的根变换成多项式系数即为所求
 for i=2:2:2*K
     Brow = broots(i:1:i+1,:);
     Brow = real(ploy(Brow));
     B(fix(i+1)/2,:) = Brow;
     Arow = aroots(i:1:i+1,:);
     Arow = real(poly(Arow));
     A(fix(1+1)/2,:) = Arow;
 end