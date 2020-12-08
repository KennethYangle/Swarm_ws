function [u,ux1,uy1,tunnel_locate,bottem_tunnel_locate,dist]  = TixingTunnel(tunnel_left,tunnel_right,Pcur,Vcur,N,gain,vmax,rs,ra)
% V21,dis,V31,b_mp,nc,V11,
line_left=zeros(length(tunnel_left(:,1))-1,2);
line_right=zeros(length(tunnel_left(:,1))-1,2);
line_end=zeros(length(tunnel_left(:,1))-1,2);
line_start=zeros(length(tunnel_left(:,1))-1,2);

nc=zeros(length(tunnel_left(:,1))-1,2);
nl=zeros(length(tunnel_left(:,1))-1,2);
nr=zeros(length(tunnel_left(:,1))-1,2);
ns=zeros(length(tunnel_left(:,1))-1,2);

c=zeros(length(tunnel_left(:,1))-1,2);
l=zeros(length(tunnel_left(:,1))-1,2);
r=zeros(length(tunnel_left(:,1))-1,2);
s=zeros(length(tunnel_left(:,1))-1,2);


p_fl=zeros(length(tunnel_left(:,1))-1,2);
p_fr=zeros(length(tunnel_left(:,1))-1,2);
p_sl=zeros(length(tunnel_left(:,1))-1,2);
p_sr=zeros(length(tunnel_left(:,1))-1,2);

p_sll=zeros(length(tunnel_left(:,1))-1,2);
p_srr=zeros(length(tunnel_left(:,1))-1,2);

line_left=diff(tunnel_left);
line_right=diff(tunnel_right);
line_end=tunnel_right(2:end,:)-tunnel_left(2:end,:);
line_start=tunnel_right(1:end-1,:)-tunnel_left(1:end-1,:);


for i=1:length(tunnel_left(:,1))-1
    rot_nc=[0 1;-1 0]; %顺时针90度
    rot_nl=[0 1;-1 0];
    rot_nr=[0 -1;1 0]; %逆时针90度
    rot_ns=[0 -1;1 0];
    
    A=rot_nc*line_end(i,:)';
    B=rot_nl*line_left(i,:)';
    C=rot_nr*line_right(i,:)';
    D=rot_ns*line_start(i,:)';
    
    nc(i,:)=(A/norm(A))';
    nl(i,:)=(B/norm(B))';
    nr(i,:)=(C/norm(C))';
    ns(i,:)=(D/norm(D))';
    
    c(i,:)=line_end(i,:)/norm(line_end(i,:));
    l(i,:)=line_left(i,:)/norm(line_left(i,:));
    r(i,:)=line_right(i,:)/norm(line_right(i,:));
    s(i,:)=line_start(i,:)/norm(line_start(i,:));
    
end

for j=1:length(tunnel_left(:,1))-1
    p_fl(j,:)=tunnel_left(j+1,:);
    p_fr(j,:)=tunnel_right(j+1,:);
    p_sl(j,:)=tunnel_left(j,:);
    p_sr(j,:)=tunnel_right(j,:);
    
    p_sll(j,1)=p_sr(j,1)+(l(j,1)*c(j,1)*(p_fl(j,2)-p_sr(j,2))-l(j,2)*c(j,1)*(p_fl(j,1)-p_sr(j,1)))/(l(j,1)*c(j,2)-l(j,2)*c(j,1));
    p_sll(j,2)=p_sr(j,2)+(l(j,1)*c(j,2)*(p_fl(j,2)-p_sr(j,2))-l(j,2)*c(j,2)*(p_fl(j,1)-p_sr(j,1)))/(l(j,1)*c(j,2)-l(j,2)*c(j,1));
    
    p_srr(j,1)=p_sl(j,1)+(r(j,1)*c(j,1)*(p_fr(j,2)-p_sl(j,2))-r(j,2)*c(j,1)*(p_fr(j,1)-p_sl(j,1)))/(r(j,1)*c(j,2)-r(j,2)*c(j,1));
    p_srr(j,2)=p_sl(j,2)+(r(j,1)*c(j,2)*(p_fr(j,2)-p_sl(j,2))-r(j,2)*c(j,2)*(p_fr(j,1)-p_sl(j,1)))/(r(j,1)*c(j,2)-r(j,2)*c(j,1));
end

tunnel_locate=zeros(N,1);
for i=1:N
    for j=1:length(tunnel_left(:,1))-1
        if dot(nl(j,:),(Pcur(i,1:2)-p_fl(j,:)))>=0 && dot(nr(j,:),(Pcur(i,1:2)-p_fr(j,:)))>=0 ...
                && dot(nc(j,:),(Pcur(i,1:2)-p_fr(j,:)))>=0 && dot(ns(j,:),(Pcur(i,1:2)-p_sr(j,:)))>=0
            tunnel_locate(i)=j;
        end
    end
end

e1=zeros(N,2);
V1=zeros(N,2);
V2=zeros(N,2);
V3=zeros(N,2);
V=zeros(N,2);
u=zeros(N,2);
dist=10^5;
A_mp=zeros(2,2);
b_mp=zeros(2,1);
A_plpr=zeros(2,2);
b_plpr=zeros(2,1);
% c_N=zeros(N,2);
bottem_tunnel_locate=zeros(N,1);

rs11=zeros(length(tunnel_left(:,1)),2);
for i=1:length(tunnel_left(:,1))-1
    rs11(i)=rs/min(-dot(nc(i,:),l(i,:)),-dot(nc(i,:),r(i,:)));
end
rs11(length(tunnel_left(:,1)))=rs;
%rs11(length(tunnel_left(:,1))+1)=0;
rs1=rs*ones(N,1);
v_line=vmax;

for i=1:N
    if tunnel_locate(i)~=0
        p_sll_sr=(p_sll(tunnel_locate(i),:)+p_sr(tunnel_locate(i),:))/2;
        p_srr_sl=(p_srr(tunnel_locate(i),:)+p_sl(tunnel_locate(i),:))/2;
        if dot(nl(tunnel_locate(i),:),(p_sll_sr-p_fl(tunnel_locate(i),:)))>=0 && dot(nr(tunnel_locate(i),:),(p_sll_sr-p_fr(tunnel_locate(i),:)))>=0 ...
                && dot(nc(tunnel_locate(i),:),(p_sll_sr-p_fr(tunnel_locate(i),:)))>=0 && dot(ns(tunnel_locate(i),:),(p_sll_sr-p_sr(tunnel_locate(i),:)))>=0
            if dot(nc(tunnel_locate(i),:),(Pcur(i,1:2)-p_sll(tunnel_locate(i))))>0
                e1(i,:) = -ns(tunnel_locate(i),:)*(v_line);
                bottem_tunnel_locate(i)=1;
                if tunnel_locate(i)==1
                    rs1(i)=rs11(tunnel_locate(i));
                else
                    rs1(i)=max(rs11(tunnel_locate(i)-1),rs11(tunnel_locate(i)));
                end
                
                A_mp(1,1)= 2+l(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp(1,2)=  -l(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp(2,1)=   l(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp(2,2)= 2-l(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp=A_mp/2;
                
                b_mp(1,1)=  (l(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                b_mp(2,1)=  (l(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                b_mp=b_mp/2;
                
                
                A_plpr(1,1)= l(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_plpr(1,2)=-l(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_plpr(2,1)= l(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_plpr(2,2)=-l(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                
                b_plpr(1,1)=(l(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                b_plpr(2,1)=(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                
                et=10^(-1);e = 0.000001;
                k3=1;
                ksii=Pcur(i,1:2) + 1/gain*Vcur(i,1:2);
                mpi=(A_mp*Pcur(i,1:2)'+b_mp)';
                mksii=(A_mp*ksii'+b_mp)';
                ksiti = Pcur(i,1:2) + 1/gain*Vcur(i,1:2) - mksii;
                rtksii=0.5*sqrt(ksii*(A_plpr'*A_plpr)*ksii'+ksii*A_plpr'*b_plpr+b_plpr'*A_plpr*ksii'+b_plpr'*b_plpr);
                rtkpi=0.5*sqrt(Pcur(i,1:2)*(A_plpr'*A_plpr)*Pcur(i,1:2)'+Pcur(i,1:2)*A_plpr'*b_plpr+b_plpr'*A_plpr*Pcur(i,1:2)'+b_plpr'*b_plpr);
                
                pti = Pcur(i,1:2) - mpi;
                disti =  rtkpi - norm(pti);
                if disti<dist
                    dist=disti;
                end
                
                
                temp_t=(rtksii-rs1(i))-norm(ksiti)*mys((rtksii-rs1(i))/(norm(ksiti)+et),e);
                dVtidksiti=(-k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t+k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(mys((rtksii-rs1(i))/(norm(ksiti)+et),e)-norm(ksiti)*(rtksii-rs1(i))/((norm(ksiti)+et)^2)*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                dVtidrtksii=(k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t-k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(1-(norm(ksiti)/(norm(ksiti)+et))*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                ci=dVtidksiti*ksiti/norm(ksiti)+dVtidrtksii*(drtpdp(ksiti',A_plpr,b_plpr))';
                V3(i,:)=-((eye(2)-A_mp)*ci')';
                if isnan(V3(i,1)) || isnan(V3(i,2))
                    V3(i,:)=[0,0];
                end
            end
            
            if dot(nc(tunnel_locate(i),:),(Pcur(i,1:2)-p_sll(tunnel_locate(i))))<=0
                e1(i,:) = nc(tunnel_locate(i),:)*(v_line);
                rs1(i)=max(rs11(tunnel_locate(i)),rs11(tunnel_locate(i)+1));
                bottem_tunnel_locate(i)=9;
                
                A_mp(1,1)= 2+l(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp(1,2)=  -l(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp(2,1)=   l(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp(2,2)= 2-l(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp=A_mp/2;
                
                b_mp(1,1)=  (l(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                b_mp(2,1)=  (l(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                b_mp=b_mp/2;
                
                
                A_plpr(1,1)= l(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_plpr(1,2)=-l(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_plpr(2,1)= l(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_plpr(2,2)=-l(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                
                b_plpr(1,1)=(l(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                b_plpr(2,1)=(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                
                et=10^(-1);e = 0.000001;
                k3=1;
                ksii=Pcur(i,1:2) + 1/gain*Vcur(i,1:2);
                mpi=(A_mp*Pcur(i,1:2)'+b_mp)';
                mksii=(A_mp*ksii'+b_mp)';
                ksiti = Pcur(i,1:2) + 1/gain*Vcur(i,1:2) - mksii;
                rtksii=0.5*sqrt(ksii*(A_plpr'*A_plpr)*ksii'+ksii*A_plpr'*b_plpr+b_plpr'*A_plpr*ksii'+b_plpr'*b_plpr);
                rtkpi=0.5*sqrt(Pcur(i,1:2)*(A_plpr'*A_plpr)*Pcur(i,1:2)'+Pcur(i,1:2)*A_plpr'*b_plpr+b_plpr'*A_plpr*Pcur(i,1:2)'+b_plpr'*b_plpr);
                
                pti = Pcur(i,1:2) - mpi;
                disti =  rtkpi - norm(pti);
                if disti<dist
                    dist=disti;
                end
                
                temp_t=(rtksii-rs1(i))-norm(ksiti)*mys((rtksii-rs1(i))/(norm(ksiti)+et),e);
                dVtidksiti=(-k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t+k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(mys((rtksii-rs1(i))/(norm(ksiti)+et),e)-norm(ksiti)*(rtksii-rs1(i))/((norm(ksiti)+et)^2)*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                dVtidrtksii=(k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t-k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(1-(norm(ksiti)/(norm(ksiti)+et))*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                ci=dVtidksiti*ksiti/norm(ksiti)+dVtidrtksii*(drtpdp(ksiti',A_plpr,b_plpr))';
                V3(i,:)=-((eye(2)-A_mp)*ci')';
                if isnan(V3(i,1)) || isnan(V3(i,2))
                    V3(i,:)=[0,0];
                end
            end
        end
        
        if dot(nl(tunnel_locate(i),:),(p_srr_sl-p_fl(tunnel_locate(i),:)))>=0 && dot(nr(tunnel_locate(i),:),(p_srr_sl-p_fr(tunnel_locate(i),:)))>=0 ...
                && dot(nc(tunnel_locate(i),:),(p_srr_sl-p_fr(tunnel_locate(i),:)))>=0 && dot(ns(tunnel_locate(i),:),(p_srr_sl-p_sr(tunnel_locate(i),:)))>=0
            if dot(nc(tunnel_locate(i),:),(Pcur(i,1:2)-p_srr(tunnel_locate(i))))>0
                e1(i,:) = -ns(tunnel_locate(i),:)*(v_line);
                bottem_tunnel_locate(i)=2;
                if tunnel_locate(i)==1
                    rs1(i)=rs11(tunnel_locate(i));
                else
                    rs1(i)=max(rs11(tunnel_locate(i)-1),rs11(tunnel_locate(i)));
                end
                
                A_mp(1,1)= 2+l(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp(1,2)=  -l(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp(2,1)=   l(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp(2,2)= 2-l(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_mp=A_mp/2;
                
                b_mp(1,1)=  (l(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                b_mp(2,1)=  (l(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                b_mp=b_mp/2;
                
                
                A_plpr(1,1)= l(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),2)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_plpr(1,2)=-l(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),1)*s(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_plpr(2,1)= l(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-r(tunnel_locate(i),2)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                A_plpr(2,2)=-l(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))+r(tunnel_locate(i),1)*s(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                
                b_plpr(1,1)=(l(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                b_plpr(2,1)=(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*s(tunnel_locate(i),2)-l(tunnel_locate(i),2)*s(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*s(tunnel_locate(i),2)-r(tunnel_locate(i),2)*s(tunnel_locate(i),1));
                
                et=10^(-1);e = 0.000001;
                k3=1;
                ksii=Pcur(i,1:2) + 1/gain*Vcur(i,1:2);
                mpi=(A_mp*Pcur(i,1:2)'+b_mp)';
                mksii=(A_mp*ksii'+b_mp)';
                ksiti = Pcur(i,1:2) + 1/gain*Vcur(i,1:2) - mksii;
                rtksii=0.5*sqrt(ksii*(A_plpr'*A_plpr)*ksii'+ksii*A_plpr'*b_plpr+b_plpr'*A_plpr*ksii'+b_plpr'*b_plpr);
                rtkpi=0.5*sqrt(Pcur(i,1:2)*(A_plpr'*A_plpr)*Pcur(i,1:2)'+Pcur(i,1:2)*A_plpr'*b_plpr+b_plpr'*A_plpr*Pcur(i,1:2)'+b_plpr'*b_plpr);
                
                pti = Pcur(i,1:2) - mpi;
                disti =  rtkpi - norm(pti);
                if disti<dist
                    dist=disti;
                end
                
                temp_t=(rtksii-rs1(i))-norm(ksiti)*mys((rtksii-rs1(i))/(norm(ksiti)+et),e);
                dVtidksiti=(-k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t+k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(mys((rtksii-rs1(i))/(norm(ksiti)+et),e)-norm(ksiti)*(rtksii-rs1(i))/((norm(ksiti)+et)^2)*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                dVtidrtksii=(k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t-k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(1-(norm(ksiti)/(norm(ksiti)+et))*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                ci=dVtidksiti*ksiti/norm(ksiti)+dVtidrtksii*(drtpdp(ksiti',A_plpr,b_plpr))';
                V3(i,:)=-((eye(2)-A_mp)*ci')';
                if isnan(V3(i,1)) || isnan(V3(i,2))
                    V3(i,:)=[0,0];
                end
            end
            
            if dot(nc(tunnel_locate(i),:),(Pcur(i,1:2)-p_srr(tunnel_locate(i))))<=0
                e1(i,:) = nc(tunnel_locate(i),:)*(v_line);
                rs1(i)=max(rs11(tunnel_locate(i)),rs11(tunnel_locate(i)+1));
                bottem_tunnel_locate(i)=10;
                
                A_mp(1,1)= 2+l(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp(1,2)=  -l(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp(2,1)=   l(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp(2,2)= 2-l(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_mp=A_mp/2;
                
                b_mp(1,1)=  (l(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                b_mp(2,1)=  (l(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                b_mp=b_mp/2;
                
                
                A_plpr(1,1)= l(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),2)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_plpr(1,2)=-l(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),1)*c(tunnel_locate(i),1)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_plpr(2,1)= l(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-r(tunnel_locate(i),2)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                A_plpr(2,2)=-l(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))+r(tunnel_locate(i),1)*c(tunnel_locate(i),2)/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                
                b_plpr(1,1)=(l(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                b_plpr(2,1)=(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fl(tunnel_locate(i),1))/(l(tunnel_locate(i),1)*c(tunnel_locate(i),2)-l(tunnel_locate(i),2)*c(tunnel_locate(i),1))-(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),2)*p_fr(tunnel_locate(i),1))/(r(tunnel_locate(i),1)*c(tunnel_locate(i),2)-r(tunnel_locate(i),2)*c(tunnel_locate(i),1));
                
                et=10^(-1);e = 0.000001;
                k3=1;
                ksii=Pcur(i,1:2) + 1/gain*Vcur(i,1:2);
                mpi=(A_mp*Pcur(i,1:2)'+b_mp)';
                mksii=(A_mp*ksii'+b_mp)';
                ksiti = Pcur(i,1:2) + 1/gain*Vcur(i,1:2) - mksii;
                rtksii=0.5*sqrt(ksii*(A_plpr'*A_plpr)*ksii'+ksii*A_plpr'*b_plpr+b_plpr'*A_plpr*ksii'+b_plpr'*b_plpr);
                rtkpi=0.5*sqrt(Pcur(i,1:2)*(A_plpr'*A_plpr)*Pcur(i,1:2)'+Pcur(i,1:2)*A_plpr'*b_plpr+b_plpr'*A_plpr*Pcur(i,1:2)'+b_plpr'*b_plpr);
                
                pti = Pcur(i,1:2) - mpi;
                disti =  rtkpi - norm(pti);
                if disti<dist
                    dist=disti;
                end
                
                temp_t=(rtksii-rs1(i))-norm(ksiti)*mys((rtksii-rs1(i))/(norm(ksiti)+et),e);
                dVtidksiti=(-k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t+k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(mys((rtksii-rs1(i))/(norm(ksiti)+et),e)-norm(ksiti)*(rtksii-rs1(i))/((norm(ksiti)+et)^2)*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                dVtidrtksii=(k3*dmysigma(rtksii-norm(ksiti),rs1(i),ra)*temp_t-k3*mysigma(rtksii-norm(ksiti),rs1(i),ra)*(1-(norm(ksiti)/(norm(ksiti)+et))*dmys((rtksii-rs1(i))/(norm(ksiti)+et),e)))/(temp_t^2);
                ci=dVtidksiti*ksiti/norm(ksiti)+dVtidrtksii*(drtpdp(ksiti',A_plpr,b_plpr))';
                V3(i,:)=-((eye(2)-A_mp)*ci')';
                if isnan(V3(i,1)) || isnan(V3(i,2))
                    V3(i,:)=[0,0];
                end
            end
        end
        
        V1(i,:) = -mysat(e1(i,:),vmax);
        if isnan(V1(i,1)) || isnan(V1(i,2))
            V1(i,:)=[0,0];
        end
    end
    
    for j=1:N
        if i~=j
            em = 10^(-6); es=10^(-6); %%两个参数，es不需要变，em和增益k2共同决定V4的数量级
            k2 = 1;
            
            ksimil = (Pcur(i,:) - Pcur(j,:)) + 1/gain*(Vcur(i,1:2) - Vcur(j,1:2));  %%两架飞机的位置差
            temp = (1+em)*norm(ksimil) - (2*rs)*mys(norm(ksimil)/(2*rs),es); %%函数分子
            bil = k2*dmysigma(norm(ksimil),2*rs,rs+ra)/temp - k2*mysigma(norm(ksimil),2*rs,rs+ra)*((1+em)-dmys(norm(ksimil)/(2*rs),es))/(temp^2);
            V2(i,:) = V2(i,:)- bil*(ksimil/norm(ksimil)); %%V2为所有避障分量之和
            if isnan(V2(i,1)) || isnan(V2(i,2))  %% 防止出现Nan导致仿真出错，非必须
                V2(i,:)=[0,0];
            end
        end
    end
    V3(i,:)=mysat(V3(i,:),2*vmax);
    V(i,:)=mysat(V1(i,:)+V2(i,:)+V3(i,:),vmax);
end

% u= [V(1,1:2),0;V(2,1:2),0;V(3,1:2),0;V(4,1:2),0;V(5,1:2),0;V(6,1:2),0;V(7,1:2),0;V(8,1:2),0;V(9,1:2),0;V(10,1:2),0;V(11,1:2),0;V(12,1:2),0;V(13,1:2),0;V(14,1:2),0;V(15,1:2),0;V(16,1:2),0;V(17,1:2),0;V(18,1:2),0;V(19,1:2),0;V(20,1:2),0];
% u= [V(1,1:2);V(2,1:2);V(3,1:2);V(4,1:2);V(5,1:2);V(6,1:2);V(7,1:2);V(8,1:2);V(9,1:2);V(10,1:2);V(11,1:2);V(12,1:2);V(13,1:2);V(14,1:2);V(15,1:2);V(16,1:2);V(17,1:2);V(18,1:2);V(19,1:2);V(20,1:2)];
u= V(1:N,1:2);
ux1 = u(:,1);
uy1 = u(:,2);