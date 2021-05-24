
clear all;
close all;

switch_value = 1; 
downsample_nr = 10;
N = 25;
tic
switch switch_value
    case 1
        load no_lp_20;
        t = no_lp_20.X.Data';
        Y = no_lp_20.Y(1).Data';
        x = no_lp_20.Y(3).Data';
      
        savefile = 'mudata_20hz';
end

t = t(15001:end-1)-(1.5-1e-5);
x = x(15001:end-1);
Y = Y(15001:end-1);

t = decimate(t,downsample_nr);
Y = decimate(Y,downsample_nr);
x = decimate(x,downsample_nr);
plot(t,x)

[mu, y, AMP,pgrid,alpha,beta,A,RA,h,N,d] = preisach_id_cont(t,x,Y,N);
        
save(savefile, 'mu','t','N','alpha','beta','x','A','Y','pgrid','y','RA','h','N','d');
toc

distribution = zeros(N,N);
k = 0;
for i = N:-1:1
    for j = i:-1:1
        k = k+1;
        distribution(i,j)= mu(k);
    end
end

figure(1);clf(1);
bar3(distribution,1);
axis([0.5 length(distribution(1,:))+0.5 0.5 length(distribution(1,:))+0.5 0 1.1*max(max(distribution))]); %+-0.5 since the bar width is 1
set(gca,'XTick',1:((length(pgrid)-1)/5):length(pgrid));
set(gca,'YTick',1:((length(pgrid)-1)/5):length(pgrid));
labelcell = convertTableToCell(pgrid(end):(pgrid(1)-pgrid(end))/5:pgrid(1));
set(gca,'XTickLabel',labelcell);
set(gca,'YTickLabel',labelcell);
xlabel('\alpha [V]');
ylabel('\beta [V]');
zlabel('Preisach Density [V]');

figure(2);clf(2);
plot(t,y,t,Y);
grid on;
axis([0,t(end) -1.1*abs(min(y)) 1.1*max(y)]);
title('Fitted and measured output');
ylabel('Voltage [V]');
xlabel('Time [s]');        
legend('fitted output','measured output');


figure(3);clf(3);
plot(t,y-Y);
grid on;
axis([0,t(end) -1.1*abs(min(y-Y)) 1.1*max(y-Y)]);
ylabel('Voltage error [V]');
xlabel('Time [s]');        

figure(4);clf(4);
plot(t,-x);
grid on;
axis([0,0.05999 -1.1*abs(min(x)) 1.1*max(x)]);
ylabel('Voltage input [V]');
xlabel('Time [s]');  
%%
L = length(y);
L_wave = round(L/5);

figure(5);clf(5);
hold on;
grid on;
plot(t(1:L_wave+1),5*Y(1*L_wave:2*L_wave),'b','LineWidth',2);
plot(t(1:L_wave+1),5*y(1*L_wave:2*L_wave),'r--','LineWidth',2);
axis([t(1) t(L_wave+1) 1.1*min(5*[y;Y]) 1.1*max(5*[y;Y])]);
legend('Measured Output','Hysteresis Model Output');
xlabel('Time [s]');
ylabel('Displacement [\mum]');

figure(6);clf(6);
hold on;grid on;
plot(x(1*L_wave:2*L_wave),5*Y(1*L_wave:2*L_wave),'LineWidth',2);
plot(x(1*L_wave:2*L_wave),5*y(1*L_wave:2*L_wave),'r--','LineWidth',2);
legend('Measured Response','Hysteresis Model Response','Location','SouthEast');
xlabel('Input Voltage [V]');
ylabel('Displacement [\mum]');

figure(7);clf(7);
hold on; grid on;
plot(t(1:L_wave+1),x(1*L_wave:2*L_wave),'b','LineWidth',2);
axis([t(1) t(L_wave+1) 1.1*min(x) 1.1*max(x)]);
xlabel('Time [s]');
ylabel('Input Voltage [V]');

% Y_nodelay = Y_nodelay(15001:end-1);
% Y_nodelay = decimate(Y_nodelay,downsample_nr);
% 
% figure(8);clf(8);
% plot(t,Y,t,Y_nodelay);
% grid on;