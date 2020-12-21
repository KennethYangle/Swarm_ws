function u=mysatNum(x,min,max)
% ensure the direction to be the same
if x>max
    u =max;
elseif x<min
    u =min;
else
    u =x ;
end
