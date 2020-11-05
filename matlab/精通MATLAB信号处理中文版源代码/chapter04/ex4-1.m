data = [1:0.2:4]';
windowSize = 5;
filter(ones(1,windowSize)/windowSize,1,data)		% b=(1/5 1/5 1/5 1/5 1/5), a=1
