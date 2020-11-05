n=input('input  n=');	%输入数据
while n~=1			
      r=rem(n,2);	%求n/2的余数
      if r ==0
         n=n/2	%第一种操作
      else
         n=3*n+1	%第二种操作
      end
end
