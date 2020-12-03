function out = mycircle_obstacle(o,r)
 alpha = 0:pi/20:2*pi;    
 x = o(1) +  r*cos(alpha); 
 y = o(2) +  r*sin(alpha); 
 fill(x,y,'r') 