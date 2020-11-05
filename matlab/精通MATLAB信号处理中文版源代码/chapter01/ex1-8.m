price=input('请输入商品价格');
switch fix(price/100) 
   case {0,1}             %价格小于200
      rate=0;
   case {2,3,4}            %价格大于等于200但小于500
      rate=0.1/100;
   case num2cell(5:9)       %价格大于等于500但小于1000
      rate=0.2/100;
   case num2cell(10:24)     %价格大于等于1000但小于2500
      rate=0.3/100;
 
end
price=price*(1-rate)              %输出商品实际销售价格
