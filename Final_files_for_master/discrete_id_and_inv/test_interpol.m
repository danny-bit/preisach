clear all;
close all;
load invert_rising_sine_20hz_100_disc_N100;
% 
% t = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17];
% u = [1 1 1 4 4 4 6 6 6 4 4 0 0 0 3 3 3 2];

[t_step,u_step] = find_steps_middle(t,u);

Ts = 1e-4;
Fs = 1/Ts;
xq = 0:Ts:t(end);

vq = interp1(t_step,u_step,xq,'linear','extrap');

figure(1);clf(1);
plot(t,u,xq,vq,'r');
% 
% figure(2);clf(2);
% plot(Y,vq);
% 
% figure(3);clf(3);
% plot(t,Y);

% figure(1);clf(1);
% stairs(t,u)
% hold on;
% plot(b(1,:),b(2,:),'r');

% x = 0:pi/4:2*pi;
% v = sin(x);
% xq = 0:pi/16:2*pi;
% figure
% vq1 = interp1(x,v,xq);
% plot(x,v,'o',xq,vq1);
% xlim([0 2*pi]);
% title('(Default) Linear Interpolation');