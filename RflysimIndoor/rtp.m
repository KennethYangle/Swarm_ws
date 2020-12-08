function u=rtp(p,A_plpr,b_plpr)
u=0.5*sqrt(p'*(A_plpr'*A_plpr)*p+p'*A_plpr'*b_plpr+b_plpr'*A_plpr*p+b_plpr'*b_plpr);
end