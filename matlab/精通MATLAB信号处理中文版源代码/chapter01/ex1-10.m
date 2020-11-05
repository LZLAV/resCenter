a=4;b=7;
for i=1:4
   b=b+1;
   if i<2
      continue 	%当if条件满足时不再执行后面语句
   end
   a=a+2       	%当i<2时不执行该语句
end
