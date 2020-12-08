clear;
clc;
global N l_v 
N=1;
l_v=5;
ts=0.05;

v_max=3;
k1=1;

rs=0.25;
ra=0.6;

width=3.5;
EncirclePoint=[113,1.7;161,-9;211,-5;248,-18;262,-6;260,13;252,27;202,29;132,23;116,16;113,1.7];
EncirclePoint_x=EncirclePoint(:,1);
EncirclePoint_y=EncirclePoint(:,2);
k=length(EncirclePoint_x);
xx=csape(1:k,EncirclePoint_x,'periodic');
yy=csape(1:k,EncirclePoint_y,'periodic');
curve_x=ppval(xx,linspace(1,k,100*k));
curve_y=ppval(yy,linspace(1,k,100*k));
p_radius=[curve_x;curve_y]';
nc=zeros(length(p_radius(:,1)),2);
for i=1:length(p_radius(:,1))-1
    nc(i,:)=(p_radius(i+1,:)-p_radius(i,:))/norm(p_radius(i+1,:)-p_radius(i,:));
end
nc(end,:)=(p_radius(1,:)-p_radius(end,:))/norm(p_radius(1,:)-p_radius(end,:));
rot1=[0 -1;1 0]; %逆时针90度
rot2=[0 1;-1 0]; %顺时针90度
p_left_encircle=zeros(length(p_radius(:,1)),2);
p_right_encircle=zeros(length(p_radius(:,1)),2);
for i=1:length(p_radius(:,1))
    p_left_encircle(i,:)=p_radius(i,:)+width*(rot1*nc(i,:)')';%p_left是该点前进方向垂直正90度的点，距离有最大限制
    p_right_encircle(i,:)=p_radius(i,:)+width*(rot2*nc(i,:)')';%p_right是该点前进方向垂直正90度的点，距离有最大限制
end
tunnel_left  =[90,20;147,14];
tunnel_right=[90,1;147,7];
p_target=[200,10];

figure(1)
hold on;
axis equal
plot(EncirclePoint_x,EncirclePoint_y,'bo',curve_x,curve_y);
plot([p_left_encircle(:,1);p_left_encircle(end,1)],[p_left_encircle(:,2);p_left_encircle(1,2)],'k--','Linewidth',1);
plot([p_right_encircle(:,1);p_right_encircle(end,1)],[p_right_encircle(:,2);p_right_encircle(1,2)],'k--','Linewidth',1);
plot(tunnel_left(:,1),tunnel_left(:,2),'k--','Linewidth',1);
plot(tunnel_right(:,1),tunnel_right(:,2),'k--','Linewidth',1);

% % figure(2)
% % set(gcf,'unit','centimeters','position',[1,1,18,18]);
% for i=1:50:length(Pcur.data(1,1,:))
%     hold on;
%     axis([-40,80,-40,40]);
%     axis equal
%     for j=1:N
%         mycircle_target(p_target_v.data(i,1:2),ra);
%         %plot(p_target.data(:,1,i),p_target.data(:,2,i),'k','Linewidth',0.5);
%         plot([p_left_v.data(:,1,i);p_left_v.data(end,1,i)],[p_left_v.data(:,2,i);p_left_v.data(1,2,i)],'k--','Linewidth',1);
%         plot([p_right_v.data(:,1,i);p_right_v.data(end,1,i)],[p_right_v.data(:,2,i);p_right_v.data(1,2,i)],'k--','Linewidth',1);
%         mycircle_r(Pcur.data(j,1:2,i),rs);
%         mycircle_b(Pcur.data(j,1:2,i),ra);
% %         for k=1:length(obstacle(:,1))
% %             mycircle_obstacle(obstacle(k,1:2),obstacle(k,3))
% %         end
%     end
%     pause(0.005);    
%     hold off
%     plot(0,0);
% end





