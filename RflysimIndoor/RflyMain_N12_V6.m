% clear;
% clc;
global N l_v 
N=12;
l_v=5;
ts=0.05;

v_max=3;
k1=1;

rs=0.25;
ra=0.6;
rt_s=0.25;
rt_a=1.5;

p_target=[200,10];

Bus_type=SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9;

% figure(1)
% hold on;
% axis equal
% plot(EncirclePoint_x,EncirclePoint_y,'bo',curve_x,curve_y);
% plot([p_left_encircle(:,1);p_left_encircle(end,1)],[p_left_encircle(:,2);p_left_encircle(1,2)],'k--','Linewidth',1);
% plot([p_right_encircle(:,1);p_right_encircle(end,1)],[p_right_encircle(:,2);p_right_encircle(1,2)],'k--','Linewidth',1);
% plot(tunnel_left(:,1),tunnel_left(:,2),'k--','Linewidth',1);
% plot(tunnel_right(:,1),tunnel_right(:,2),'k--','Linewidth',1);

% figure(2)
% set(gcf,'unit','centimeters','position',[1,1,18,18]);
figure(1)
for i=1:50:length(p_radius.data(1,1,:))
    hold on;
    axis([80,300,-40,50]);
    axis equal
    plot(p_radius.data(:,1,i),p_radius.data(:,2,i),'r--','Linewidth',1);
    plot(p_left_encircle.data(:,1,i),p_left_encircle.data(:,2,i),'b--','Linewidth',1);
    plot(p_right_encircle.data(:,1,i),p_right_encircle.data(:,2,i),'g--','Linewidth',1);
    plot(Pcur.data(:,1,i),Pcur.data(:,2,i),'r','Linewidth',0.2);
end





