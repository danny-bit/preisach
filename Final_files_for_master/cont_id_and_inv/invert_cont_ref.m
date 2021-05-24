clear all;
close all;

load mudata_20hz;

savefile = 'invert_data_20hz';
NumOfCycles = 5;
FREQ = 5;
Ts = 1e-4;
t = 0:Ts:NumOfCycles/FREQ-Ts*200;
% gain = linspace(0,2.5,length(t));
% Y = -(0.5+gain).*cos(2*pi*FREQ*t);
Y = 2.*sin(2*pi*FREQ*t);

isleft = 1;

u = zeros(1,length(t));
y_inv = zeros(1,length(t));

for i=1:length(t)
    if mod(i,1000) == 0 
        disp(num2str(i));
    end
    [u(i), y_inv(i)] = invert_presiach_cont(Y(i),pgrid, isleft, A,mu,d,0.9);
end
%%
figure(1);clf(1);
plot(t,u);
grid on;
xlabel('Time [s]');
ylabel('Calculated Inverse Input [V]');

figure(2);clf(2);
hold on;
plot(t,5*Y,'Linewidth',2);
plot(t,5*y_inv,'r');
grid on;
xlabel('Time [s]');
ylabel('Displacement [\mum]');
legend('Reference','Model');
axis([t(1) t(round(length(t)/5)) 5*1.1*min(Y) 5*1.1*max(Y)]);

figure(3);clf(3);
plot(t(1:end),Y(1:end)-y_inv(1:end),'LineWidth',2);
grid on;
xlabel('Time [s]');
ylabel('Voltage error [V]');
%axis([t(1) t(end) 1.1*min(Y(1:end)-y_inv(1:end)) 1.1*max(Y(1:end)-y_inv(1:end))]);
axis([t(1) t(15) 1.1*min(Y(1:end)-y_inv(1:end)) 1.1*max(Y(1:end)-y_inv(1:end))]);

figure(4);clf(4);
plot(5*Y,5*y_inv);
grid on;
axis(5*[1.1*min(Y) 1.1*max(Y) 1.1*min(y_inv) 1.1*max(y_inv)]);
xlabel('Reference Displacement [\mum]');
ylabel('Model Displacement [\mum]');

figure(5);clf(5);
plot(u,Y);
grid on;
axis([1.1*min(u) 1.1*max(u) 1.1*min(y) 1.1*max(y)]);

save(savefile, 't','u','N','Y');