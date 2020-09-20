function diffenergy = caldiffenergy(energy)
v = diff(energy);
[x,y] = size(v);
for i=1:y
    zero(i) = 0;
end
diffenergy = abs(([zero;v]));
end