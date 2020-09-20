% 选取 scope 区域内的能量最大并且能量增幅最大的点作为峰值点，进行特征值提取
function point = keypoint(sample,scope)
% 使用短时傅里叶变换得到信号的频谱图。有输出参数，则会返回输入信号的短时傅里叶变换;无输出，则自动绘制频谱图。得到变换后的数据为b,频率为 f，时间为 t
[b,f,t] = spectrogram(sample,1024,11025,hanning(1024),256);
spectrogram(sample,1024,11025,hanning(1024),256);      %绘制频谱图
hold on;
energy = abs(b);    %根据快速傅里叶变换后的数据进行能量计算
%energy = sample;
diffenergy = caldiffenergy(energy); %计算能量差分
[m,n] = size(energy);       %获取能量矩阵的大小
%f = (0:4);
%t = (0:4);
f_unit = max(f) /(length(f)-1); %根据频率点个数计算频率单位长度
t_unit = max(t)/(length(t)-1);  %根据时间点个数计算时间单位长度
k =1;
l = 1;
p =1;
num = 1;
point.t = 0;
point.f = 0; %point 结构体数组用来保存峰值点
temp.t = 0;
temp.f = 0; %temp结构体数组用来保存计算中的临时点
count = 0;  %count 为零表示在当前 scope 中未找到峰值点
x_f = 0;
y_t =0;
plot(x_f,y_t);
hold on;
for i=1:m-scope+1
   for j=1:n-scope+1
       % 找出大小为 scope 的子矩阵中的最大元素的位置并保存
       [x_f,y_t] = find(energy(i:i+scope-1,j:j+scope-1) == max(max(energy(i:i+scope-1,j:j+scope-1))));
       x_f = x_f +i -1;
       y_t = y_t +j -1;
       % 找出大小为 scope 的子矩阵中的差分最大元素的位置并保存
       [diffx,diffy] = find(diffenergy(i:i+scope-1,j:j+scope-1) == max(max(diffenergy(i:i+scope-1,j:j+scope-1))));
       diffx = diffx +i-1;
       diffy = diffy +j-1;
       count =0;
       % 如果最大元素和差分最大元素都为同一个位置则该点为峰值点，保存在 temp 中
       for k =1:length(x_f)
           for l =1:length(diffx)
               if (x_f(k) == diffx(l)) && (y_t(k)==diffy(l))
                   temp(num).f = x_f(k) * f_unit;
                   temp(num).t = y_t(k) * t_unit;
                   %plot(temp(num).t,temp(num).f,'.');
                   num = num +1;
                   count =1;    %在 scope 中找到一个峰值点则不再记录其它相同的点
                   break;
               end
           end
           if count == 1    %scope 中多个峰值点只保留第一个
               break;
           end
       end
   end
end

%将 temp 中保存的峰值点画在图上，多个 scope 中找到的相同峰值点只画一次
len = 1;
point(1).f = temp(1).f;
point(1).t = temp(1).t;
plot(point(1).t,point(1).f,'.');
for i =2:num-1
    for j=1:len
        if (temp(i).f == point(j).f) && (temp(i).t == point(j).t)
            break;
        end
    end
    if j == len && (temp(i).f ~= point(j).f) && (temp(i).t ~= point(j).t)
       len = len+1;
       point(len).f = temp(i).f;
       point(len).t = temp(i).t;
       plot(point(len).t,point(len).f,'.');
    end
    hold on;
end