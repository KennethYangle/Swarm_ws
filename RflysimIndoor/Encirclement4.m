function [u,ux,uy,uyaw,leader_locate,dist]  = Encirclement4(p_leader,tunnel_left,tunnel_right,p_target,Pcur,Vcur,Yawcur,gain,vmax,rs,ra,rt1,rt2,i)
N=3;

k_yaw=1;
ep=p_target-Pcur(i,:);
yaw_d=atan2(ep(2),ep(1));
uyaw=k_yaw*minAngleDiff(yaw_d,Yawcur(i,:));

leader_locate=0;
dis_leader_min=10^8;
for j=1:length(p_leader(:,1))
    dis_leader=norm(Pcur(i,:)-p_leader(j,:));
    if dis_leader < dis_leader_min
        leader_locate=j;
        dis_leader_min=dis_leader;
    end
end

nc=zeros(length(tunnel_left(:,1)),2);
for k=1:length(tunnel_left(:,1))
    rot=[0 -1;1 0];
    C=rot*(tunnel_right(k,:)-tunnel_left(k,:))';
    nc(k,:)=-(C/norm(C))';    
end

e1=zeros(1,2);
V1=zeros(1,2);
V2=zeros(1,2);
V3=zeros(1,2);
V=zeros(1,2);

u=zeros(1,2);
ux=zeros(1,1);
uy=zeros(1,1);

mksii=zeros(1,2);
rtksii=zeros(1,1);
ksiti=zeros(1,2);
ksii=zeros(1,2);
pti=zeros(1,2);

dis=10^5;
dist=10^5;


if leader_locate~=0
    
    v_line=vmax;
    
    k1=1;
    e1 = nc(leader_locate,:)*(v_line);
    V1 = -mysat(k1*e1,vmax);
    
    k3=3*vmax; emt=0;
    mksii=0.5*(tunnel_left(leader_locate,:)+tunnel_right(leader_locate,:));
%     ksii = Pcur(i,1:2) + 1/gain*Vcur(i,1:2);
    ksiti= Pcur(i,1:2) + 1/gain*Vcur(i,1:2) - mksii;
    rtksii=0.5*norm(tunnel_left(leader_locate,:)-tunnel_right(leader_locate,:));
    pti= Pcur(i,1:2) - mksii;
    disti =  rtksii - norm(pti);
    if disti<dist
        dist=disti;
    end
    
    dVtidksiti=k3*dmysigma2(rtksii-norm(ksiti),rt1,rt2,emt);
    ci=dVtidksiti*ksiti/norm(ksiti); 
    un=ksiti-(dot(ksiti,nc(leader_locate,:))*nc(leader_locate,:));
    V3=-(un/norm(un))*dot(un/norm(un),ci);
    
    
    for j=1:N
        if i~=j
            k2 = 3*vmax; em = 0;
            ksimil = (Pcur(i,1:2) - Pcur(j,1:2)) + 1/gain*(Vcur(i,1:2) - Vcur(j,1:2));
            bil = k2*dmysigma2(norm(ksimil),2*rs,rs+ra,em);
            V2 = V2+ bil*(ksimil/norm(ksimil));
            
            disij=norm(Pcur(i,1:2) - Pcur(j,1:2));
            if disij<dis
                dis=disij;
            end
        end
    end
end
V=mysat(V1+V2+V3,vmax);


% u = [V(1,1:2);V(2,1:2);V(3,1:2);V(4,1:2);V(5,1:2);V(6,1:2);V(7,1:2);V(8,1:2);V(9,1:2);V(10,1:2);V(11,1:2);V(12,1:2);V(13,1:2);V(14,1:2);V(15,1:2);V(16,1:2);V(17,1:2);V(18,1:2);V(19,1:2);V(20,1:2)];
u = V(1,1:2);
ux = u(:,1);
uy = u(:,2);
