function[num1,num2,num3]=text(varargin)
global  firstlevel  secondlevel              %定义全局变量
num1=0;
num2=0;
num3=0;
list=zeros(nargin);
for i=1:nargin	
  list(i)=sum(varargin{i}(:));
  list(i)=list(i)/length(varargin{i});
  if  list(i)>firstlevel
        num1=num1+1
  elseif  list(i)>secondlevel
        num2=num2+1;
  else
    num3=num3+1;
  end
end
