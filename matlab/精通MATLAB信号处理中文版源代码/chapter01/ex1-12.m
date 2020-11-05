A=[1,2;4,5]; B=[7,8;10,11];
try
   C=A*B;
catch
   C=A.*B;
end
C
lasterr	%显示出错原因
