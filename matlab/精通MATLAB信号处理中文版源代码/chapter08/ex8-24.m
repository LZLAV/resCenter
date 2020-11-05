clear; % 清理工作空间
load cathe_1
I=X;
%小波函数
type = 'db1';
% 2维离散Daubechies小波变换
[CA1, CH1, CV1, CD1] = dwt2(I,type);
C1 = [CH1 CV1 CD1];
%系数矩阵大小
[length1, width1] = size(CA1);
[M1, N1] = size(C1);
% 定义阈值T1 
T1 =50;
alpha = 0.2;
%在图像中加入水印
for counter2 = 1: 1: N1
   for counter1 = 1: 1: M1
      if( C1(counter1, counter2) > T1 )   
         marked1(counter1,counter2) = randn(1,1);
         NEWC1(counter1, counter2) = double( C1(counter1, counter2) ) + ...
alpha * abs( double( C1(counter1, counter2) ) ) * marked1(counter1,counter2) ;      
      else
         marked1(counter1, counter2) = 0;
         NEWC1(counter1, counter2) = double( C1(counter1, counter2) );
      end; 
   end;
end;
%重构图像
NEWCH1 = NEWC1(1:length1, 1:width1);
NEWCV1 = NEWC1(1:length1, width1+1:2*width1);
NEWCD1 = NEWC1(1:length1, 2*width1+1:3*width1);
R1 = double( idwt2(CA1, NEWCH1, NEWCV1, NEWCD1, type) );
watermark1 = double(R1) - double(I);
subplot(2,2,1);                      % 设置图像位置
image(I);                            % 显示原始图像
axis('square');                      % 设置轴属性  
title('原始图像');                   % 设置图像标题
subplot(2,2,2);                      % 设置图像位置
imshow(R1/250);                      % 显示变换后的图像
axis('square');                      % 设置轴属性
title('小波变换后图像');  % 设置图像标题
subplot(2,2,3);                      % 设置图像位置
imshow(watermark1*10^16);           % 显示水印图像
axis('square');                        % 设置轴属性
title('水印图像');                      % 设置图像标题
% 水印检测
newmarked1 = reshape(marked1, M1*N1, 1);
% 检测阈值
T2 = 60;
 for counter2 = 1: 1: N1
   		for counter1 = 1: 1: M1
            if( NEWC1(counter1, counter2) >T2 )
               NEWC1X(counter1, counter2) = NEWC1(counter1, counter2);
            else
               NEWC1X(counter1, counter2) = 0;
            end;
        end;
      end;
NEWC1X = reshape(NEWC1X, M1*N1, 1);
correlation1 = zeros(1000,1);
for corrcounter = 1: 1: 1000
      if( corrcounter == 500)
       correlation1(corrcounter,1) = NEWC1X'*newmarked1 / (M1*N1);
      else
       rnmark = randn(M1*N1,1);
       correlation1(corrcounter,1) = NEWC1X'*rnmark / (M1*N1);
      end;      
end;  
% 计算阈值
originalthreshold = 0;
for counter2 = 1: 1: N1
   		for counter1 = 1: 1: M1
             if( NEWC1(counter1, counter2) > T2 )
               originalthreshold = originalthreshold + abs( NEWC1(counter1, counter2) );
             end;
         end;
  end;
originalthreshold = originalthreshold * alpha / (2*M1*N1);   
corrcounter = 1000;
originalthresholdvector = ones(corrcounter,1) * originalthreshold;
subplot(2,2,4);                      % 设置图像位置
plot(correlation1, '-');                  % 绘图
hold on;                                  % 继续绘图
plot(originalthresholdvector, '--');      % 绘图
title('原始的加水印图像');                % 设置图像标题
xlabel('水印');                           % 设置x轴标签
ylabel('检测响应');                       % 设置y轴标签
