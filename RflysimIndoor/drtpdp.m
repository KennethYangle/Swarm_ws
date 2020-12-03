function u=drtpdp(p,A_plpr,b_plpr)
a=(A_plpr'*A_plpr+A_plpr*A_plpr')*p+2*A_plpr'*b_plpr;
b=4*sqrt(p'*(A_plpr'*A_plpr)*p+p'*A_plpr'*b_plpr+b_plpr'*A_plpr*p+b_plpr'*b_plpr);
u=a/b;
end