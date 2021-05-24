clear all;
close all;

switch_value = 1;
downsample_nr = 100;

N = 50;
tic
switch switch_value
        
        case 1
        load rising_sine_20hz_100;
        t = rising_sine_20hz_100.X.Data';
        Y = rising_sine_20hz_100.Y(1).Data';
        x = rising_sine_20hz_100.Y(3).Data';
        savefile = 'mu_rising_sine_20hz_100_disc_N50';
        
end

%remove vibration values:
t = t(15001:end-1)-(0.15-1e-5);
x = x(15001:end-1);
Y = Y(15001:end-1);

t = decimate(t,downsample_nr);
Y = decimate(Y,downsample_nr);
x = decimate(x,downsample_nr);

% figure(1);clf(1);
% plot(t,x);
% return;

[mu, y, AMP,pgrid,alpha,beta,A,RA,h,N,S,d] = preisach_id(t,x,Y,N);

save(savefile, 'mu','t','N','alpha','beta','x','A','Y','pgrid','y','RA','h','N','S','d');
toc
%%
distribution = zeros(N,N);
k = 0;
for i = N:-1:1
    for j = i:-1:1
        k = k+1;
        distribution(i,j)= mu(k);
    end
end

%distribution(1,49) = 0;
figure(1);clf(1);
% surf(pgrid,pgrid,distribution);
% axis([-AMP AMP -AMP AMP 0 1.1*max(max(distribution))]);
% xlabel('\alpha');
% ylabel('\beta');
% zlabel('Distribution');
bar3(distribution,1);
axis([0.5 length(distribution(1,:))+0.5 0.5 length(distribution(1,:))+0.5 0 1.1*max(max(distribution))]); %+-0.5 since the bar width is 1
set(gca,'XTick',1:((length(pgrid)-1)/5):length(pgrid));
set(gca,'YTick',1:((length(pgrid)-1)/5):length(pgrid));
labelcell = convertTableToCell(pgrid(end):(pgrid(1)-pgrid(end))/5:pgrid(1));
set(gca,'XTickLabel',labelcell);
set(gca,'YTickLabel',labelcell);
xlabel('\alpha');
ylabel('\beta');
zlabel('Distribution');
%%
figure(2);clf(2);
plot(t,y); hold on;
stairs(t,Y,'r');
grid on;
axis([t(1),t(end) -1.1*abs(min(y)) 1.1*max(y)]);
%%title('Fitted and measured output');
ylabel('Voltage [V]');
xlabel('Time [s]');        
legend('fitted output','measured output');
%%

figure(3);clf(3);
plot(t,y-Y);
grid on;
axis([0,t(end) -1.1*abs(min(y-Y)) 1.1*max(y-Y)]);
%title('Error in voltage');
ylabel('Voltage error [V]');
xlabel('Time [s]');        
%legend('fitted output','measured output');

figure(4);clf(4);
plot(t,x);
grid on;
axis([0,t(end) -1.1*abs(min(x)) 1.1*max(x)]);
%title('Error in voltage');
ylabel('Voltage input [V]');
xlabel('Time [s]');        
%legend('fitted output','measured output');

L = length(y);
L_wave = round(L/50);

figure(5);clf(5);
hold on;
grid on;
plot(t(1:L_wave+1),5*Y(1*L_wave:2*L_wave),'b','LineWidth',2);
stairs(t(1:L_wave+1),5*y(1*L_wave:2*L_wave),'r','LineWidth',2);
axis([t(1) t(L_wave+1) 1.1*min(5*[y;Y]) 1.1*max(5*[y;Y])]);
legend('Measured Output','Hysteresis Model Output');
xlabel('Time [s]');
ylabel('Displacement [\mum]');

figure(6);clf(6);
hold on;grid on;
plot(x(1*L_wave:2*L_wave),5*Y(1*L_wave:2*L_wave),'LineWidth',2);
stairs(x(1*L_wave:2*L_wave),5*y(1*L_wave:2*L_wave),'r','LineWidth',2);
legend('Measured Response','Hysteresis Model Response','Location','SouthEast');
xlabel('Input Voltage [V]');
ylabel('Displacement [\mum]');

figure(7);clf(7);
hold on; grid on;
plot(t(1:L_wave+1),x(1*L_wave:2*L_wave),'b','LineWidth',2);
axis([t(1) t(L_wave+1) 1.1*min(x) 1.1*max(x)]);
xlabel('Time [s]');
ylabel('Input Voltage [V]');
