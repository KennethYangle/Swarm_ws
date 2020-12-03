function [u,ux,uy,uyaw,leader_locate,rtksii,ksii,dist]  = Encirclement(p_leader,tunnel_left,tunnel_right,p_target,Pcur,Vcur,Yawcur,gain,vmax,rs,ra,rtksii_last,ksii_last)
N=1;

yaw_d=zeros(N,1);
uyaw=zeros(N,1);
k_yaw=1;
for i=1:N
    ep=p_target-Pcur(i,:);
    yaw_d(i)=atan2(ep(2),ep(1));
    uyaw(i)=k_yaw*(yaw_d(i)-Yawcur(i,:));
end
leader_locate=zeros(N,1);
for i=1:N
    dis_leader_min=10^8;
    for j=1:length(p_leader(:,1))
        dis_leader=norm(Pcur(i,:)-p_leader(j,:));
        if dis_leader < dis_leader_min
            leader_locate(i)=j;
            dis_leader_min=dis_leader;
        end
    end
end

nc=zeros(length(tunnel_left(:,1)),2);
for i=1:length(tunnel_left(:,1))
    rot=[0 -1;1 0]; %逆时针90度
    C=rot*(tunnel_right(i,:)-tunnel_left(i,:))';
    nc(i,:)=-(C/norm(C))';
end

e1=zeros(N,2);
V1=zeros(N,2);
V2=zeros(N,2);
V3=zeros(N,2);
V=zeros(N,2);

u=zeros(N,2);
ux=zeros(N,1);
uy=zeros(N,1);

rtksii=zeros(N,1);
ksiti=zeros(N,2);
ksii=zeros(N,2);
pti=zeros(N,2);

dis=10^5;
dist=10^5;


rs1=rs;
for i=1:N
    if leader_locate(i)~=0

        v_line=vmax;
        
        k1=1;
        e1(i,:) = nc(leader_locate(i),:)*(v_line);
        V1(i,:) = -mysat(k1*e1(i,:),vmax);
        
        et=10^(-1);e = 0.000001;
        k3=1;
        mksii=0.5*(tunnel_left(leader_locate(i),:)+tunnel_right(leader_locate(i),:));
        ksii(i,:) = Pcur(i,1:2) + 1/gain*Vcur(i,1:2);
        ksiti(i,:) = Pcur(i,1:2) + 1/gain*Vcur(i,1:2) - mksii;
        rtksii(i)=0.5*norm(tunnel_left(leader_locate(i),:)-tunnel_right(leader_locate(i),:));
        
        pti(i,:)= Pcur(i,1:2) - mksii;
        disti =  rtksii(i) - norm(pti(i,:));
        if disti<dist
            dist=disti;
        end
        
        temp_t=(rtksii(i)-rs1)-norm(ksiti(i,:))*mys((rtksii(i)-rs1)/(norm(ksiti(i,:))+et),e);
        dVtidksiti=(-k3*dmysigma(rtksii(i)-norm(ksiti(i,:)),rs1,ra)*temp_t+k3*mysigma(rtksii(i)-norm(ksiti(i,:)),rs1,ra)*(mys((rtksii(i)-rs1)/(norm(ksiti(i,:))+et),e)-norm(ksiti(i,:))*(rtksii(i)-rs1)/((norm(ksiti(i,:))+et)^2)*dmys((rtksii(i)-rs1)/(norm(ksiti(i,:))+et),e)))/(temp_t^2);
        dVtidrtksii=(k3*dmysigma(rtksii(i)-norm(ksiti(i,:)),rs1,ra)*temp_t-k3*mysigma(rtksii(i)-norm(ksiti(i,:)),rs1,ra)*(1-(norm(ksiti(i,:))/(norm(ksiti(i,:))+et))*dmys((rtksii(i)-rs1)/(norm(ksiti(i,:))+et),e)))/(temp_t^2);
        if ksii(i,1)-ksii_last(i,1)==0 || ksii(i,2)-ksii_last(i,2)==0
            drtpdksii=[0,0];
        else
            drtpdksii=[(rtksii(i)-rtksii_last(i))/(ksii(i,1)-ksii_last(i,1)),(rtksii(i)-rtksii_last(i))/(ksii(i,2)-ksii_last(i,2))];
        end
        ci=dVtidksiti*ksiti(i,:)/norm(ksiti(i,:))+dVtidrtksii*drtpdksii;
        
        un=ksiti(i,:)-(dot(ksiti(i,:),nc(leader_locate(i),:))*nc(leader_locate(i),:));
        V3(i,:)=-(un/norm(un))*dot(un/norm(un),ci);
        if isnan(V3(i,1)) || isnan(V3(i,2))
            V3(i,:)=[0,0];
        end
    end
    
    for j=1:N
        if i~=j
            k2 = 1; e = 0.000001;
            ksimil = (Pcur(i,1:2) - Pcur(j,1:2)) + 1/gain*(Vcur(i,1:2) - Vcur(j,1:2));
            temp = (1+e)*norm(ksimil) - (2*rs)*mys(norm(ksimil)/(2*rs),e);
            bil = k2*dmysigma(norm(ksimil),2*rs,rs+ra)/temp ...
                - k2*mysigma(norm(ksimil),2*rs,rs+ra)*((1+e)-dmys(norm(ksimil)/(2*rs),e))/(temp^2);
            V2(i,:) = V2(i,:)- bil*(ksimil/norm(ksimil));
            if isnan(V2(i,1)) || isnan(V2(i,2))
                V2(i,:)=[0,0];
            end
            disij=norm(Pcur(i,1:2) - Pcur(j,1:2));
            if disij<dis
                dis=disij;
            end
        end
    end
    V(i,:)=mysat(V1(i,:)+V2(i,:)+V3(i,:),vmax);
end

% u = [V(1,1:2);V(2,1:2);V(3,1:2);V(4,1:2);V(5,1:2);V(6,1:2);V(7,1:2);V(8,1:2);V(9,1:2);V(10,1:2);V(11,1:2);V(12,1:2);V(13,1:2);V(14,1:2);V(15,1:2);V(16,1:2);V(17,1:2);V(18,1:2);V(19,1:2);V(20,1:2)];
u = V(1:N,1:2);
ux = u(:,1);
uy = u(:,2);
