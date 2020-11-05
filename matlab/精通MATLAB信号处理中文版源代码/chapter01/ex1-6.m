A=input('请输入三角形的三条边：');
    if A(1)+A(2)>A(3) & A(1)+A(3)>A(2) & A(2)+A(3)>A(1)
       p=(A(1)+A(2)+A(3))/2;
       s=sqrt(p*(p-A(1))*(p-A(2))*(p-A(3)));
       disp(s);
    else
       disp('不能构成一个三角形。')
    end
