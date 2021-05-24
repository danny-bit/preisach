
clear all;
close all;

%Load model data and create file name for saving
load mu_rising_sine_20hz_100_disc_N50; savefile = 'rising_sine_20hz_invert';

%Create reference signal
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
h = waitbar(0,'Initializing waitbar...');
for i=1:length(t)
    if mod(i,100) == 0 
        str1 = 'Inverting Discrete Preisach Operator...:';
        str2 = num2str(100*(i/length(t)));
        str3 = '%'; 
        out_str = strcat(str1,str2,str3);
        waitbar(i/length(t),h,out_str);
    end
    %Create inverted input, Y is the reference
    [u(i),y_inv(i)] = invert_preisach_disc(Y(i),pgrid, isleft, A,mu,d);
end
close(h);


%%
%The three query point methods methods
[t_step_left,u_step_left] = find_steps_left(t,u);
[t_step_middle,u_step_middle] = find_steps_middle(t,u);
[t_step_top_middle,u_step_top_middle] = find_steps_top_middle(t,u);

xq = 0:Ts:t(end);

%interpolation with the left corners
vq_left = interp1(t_step_left,u_step_left,xq,'linear','extrap');


u_interpol_left = vq_left;

%save the file for experimental testing
save(savefile, 't','u','u_interpol_left','N','Y');

%plotting of everything:
%%
figure(1);clf(1);
stairs(t,u);
grid on;
xlabel('Time [s]');
ylabel('Input Voltage [V]');

figure(2);clf(2);
plot(t,5*Y,'Linewidth',2);
hold on;
stairs(t,5*y_inv,'r');
grid on;
xlabel('Time [s]');
ylabel('Displacement [\mum]');
legend('Reference','Model','Location','NorthEast');
axis([t(1) t(round(length(t)/5)) 5*1.1*min(Y) 5*1.1*max(Y)]);

figure(3);clf(3);
plot(5*Y,5*y_inv);
grid on;
xlabel('Reference Displacement [\mum]');
ylabel('Model Displacement [\mum]');
axis(5*1.1*[min(Y) max(Y) min(y_inv) max(y_inv)]);

figure(4);clf(4);
plot(Y,u);
grid on;
hold on;
plot(Y(1:200),u(1:200),'Linewidth',2);
xlabel('Reference Output [V]');
ylabel('Inverted Input [V]');
axis(1.1*[min(Y) max(Y) min(u) max(u)]);

figure(5);clf(5);
plot(u,y_inv);
grid on;
hold on;
plot(u(1:200),y_inv(1:200),'Linewidth',2);
xlabel('Inverted Input [V]');
ylabel('Inverted Model Output [V]');
axis(1.1*[min(u) max(u) min(Y) max(Y)]);

figure(6);clf(6);
hold on;
stairs(t,Y);
stairs(t,y_inv,'r');
grid on;
xlabel('Time [s]');
ylabel('Output Voltage [V]');
legend('Reference Output','Model Output');

figure(7);clf(7);
plot(Y(6000:length(vq_left)),vq_left(6000:end));
grid on;
xlabel('Reference Output [V]');
ylabel('Inverted Model Output [V]');
axis(1.1*[min(Y(1:length(vq_left))) max(Y(1:length(vq_left))) min(vq_left) max(vq_left)]);

figure(8);clf(8);
plot(t,u,xq,vq_left,'r');
xlabel('Time [s]');
ylabel('Input Voltage [V]');

figure(9);clf(9);
plot(t,Y,'b');
hold on;
grid on;
stairs(t,y_inv,'r');
