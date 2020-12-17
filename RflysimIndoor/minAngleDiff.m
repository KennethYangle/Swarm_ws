function diffab = minAngleDiff(a,b)
diff=a-b;
if diff<0
    diff=diff+2*pi;
end
if diff>0 && diff<pi
    diffab=diff;
else
    diffab=diff-2*pi;
end