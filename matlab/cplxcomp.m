function I = cplxcomp(p1,p2)
% I = cplxcomp(p1,p2)
% 比较两个包含同样标量元素但（可能）有不同下表的复数对
% 本程序必须用在 cplxpair （）程序后一遍重新排序频率极点矢量
% 及其相应的留数矢量
% p2 = cplxpair(p1)
I =[];
for j=1:length(p2)
    for i=1:length(p1)
        if(abs((p1(i) - p2(j))< 0.0001))
            I = [I,j];
        end
    end
end
I = I';
    