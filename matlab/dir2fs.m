% FIR 系统直接型结构转换为 频率采样型结构
function[C,B,A] = dir2fs(h)
% 直接型到频率采样型的转换
%[C,B,A] = dir2fs(h)
% C = 包含各并行部分增益的行向量
% B = 包含按行排列的分子系数矩阵
% A = 包含按行排列的分母系数矩阵
% h = FIR 滤波器的脉冲响应向量
M = length(h);
H = fft(h,M);
magH = abs(H);phaH = angle(H)';
% check event or odd M 
if(M ==2 * floor(M/2))
    L = M/2-1;      % M为偶数
    A1 = [1,-1,0;1,1,0];
    C1 = [real(H(1)),real(H(L+2))];
else
    L = (M-1)/2; % M is odd
    A1 = [1,-1,0];
    C1 = [real(H(1))];
end
k = [1:L]';
% 初始化B 和 A数组
B = zeros(L,2);A = ones(L,3);
% 计算分母系数
A(1:L,2) = -2* cos(2*pi*k/M);A = [A;A1];
% 计算分子系数
B(1:L,1) = cos(phaH(2:L+1));
B(1:L,2) = -cos(phaH(2:L+1) - (2*pi*k/M));
% 计算增益系数
C = [2*magH(2:L+1),C1]';
