clear all;
close all;
type_of_model =18;
reference_signal = 1;
Ts = 1e-4;
FREQ = 20;
signal_length = 10000;


switch type_of_model
    %     %Example:
    %     case 1
    %         load inv_data_sin_15_lowpass
    %         FREQ = 20;
    %         t = inv_data_sin_15_lowpass.X.Data;
    %         y = inv_data_sin_15_lowpass.Y(1).Data;
    %         u = inv_data_sin_15_lowpass.Y(3).Data;
    %         y_delay = inv_data_sin_15_lowpass.Y(2).Data;
    case 1 
        load bigsine_1;
        FREQ = 5;
        t = bigsine_1.X.Data;
        y = bigsine_1.Y(1).Data;
        u = bigsine_1.Y(3).Data;
        y_delay = bigsine_1.Y(2).Data;

    case 2
        load bigsine_2;
        FREQ = 5;
        t = bigsine_2.X.Data;
        y = bigsine_2.Y(1).Data;
        u = bigsine_2.Y(3).Data;
        y_delay = bigsine_2.Y(2).Data;
        
    case 3 
        load bigsine_3;
        FREQ = 5;
        t = bigsine_3.X.Data;
        y = bigsine_3.Y(1).Data;
        u = bigsine_3.Y(3).Data;
        y_delay = bigsine_3.Y(2).Data;
        
    case 4 
        load prbn_1;
        FREQ = 5;
        t = prbn_1.X.Data;
        y = prbn_1.Y(1).Data;
        u = prbn_1.Y(3).Data;
        y_delay = prbn_1.Y(2).Data;
        
    case 5 
        load prbn_2;
        FREQ = 5;
        t = prbn_2.X.Data;
        y = prbn_2.Y(1).Data;
        u = prbn_2.Y(3).Data;
        y_delay = prbn_2.Y(2).Data;
        
    case 6 
        load prbn_3;
        FREQ = 5;
        t = prbn_3.X.Data;
        y = prbn_3.Y(1).Data;
        u = prbn_3.Y(3).Data;
        y_delay = prbn_3.Y(2).Data;
        
    case 7 
        load sine100_1;
        FREQ = 5;
        t = sine100_1.X.Data;
        y = sine100_1.Y(1).Data;
        u = sine100_1.Y(3).Data;
        y_delay = sine100_1.Y(2).Data;
        
    case 8 
        load sine100_2;
        FREQ = 5;
        t = sine100_2.X.Data;
        y = sine100_2.Y(1).Data;
        u = sine100_2.Y(3).Data;
        y_delay = sine100_2.Y(2).Data;
        
    case 9 
        load sine100_3;
        FREQ = 5;
        t = sine100_3.X.Data;
        y = sine100_3.Y(1).Data;
        u = sine100_3.Y(3).Data;
        y_delay = sine100_3.Y(2).Data;
        
    case 10 
        load sine50_1;
        FREQ = 5;
        t = sine50_1.X.Data;
        y = sine50_1.Y(1).Data;
        u = sine50_1.Y(3).Data;
        y_delay = sine50_1.Y(2).Data;
        
    case 11
        load sine50_2;
        FREQ = 5;
        t = sine50_2.X.Data;
        y = sine50_2.Y(1).Data;
        u = sine50_2.Y(3).Data;
        y_delay = sine50_2.Y(2).Data;
        
    case 12
        load sine50_3;
        FREQ = 5;
        t = sine50_3.X.Data;
        y = sine50_3.Y(1).Data;
        u = sine50_3.Y(3).Data;
        y_delay = sine50_3.Y(2).Data;
        
    case 13
        load tri100_1;
        FREQ = 5;
        t = tri100_1.X.Data;
        y = tri100_1.Y(1).Data;
        u = tri100_1.Y(3).Data;
        y_delay = tri100_1.Y(2).Data;
        
    case 14
        load tri100_2;
        FREQ = 5;
        t = tri100_2.X.Data;
        y = tri100_2.Y(1).Data;
        u = tri100_2.Y(3).Data;
        y_delay = tri100_2.Y(2).Data;
        
    case 15
        load tri100_3;
        FREQ = 5;
        t = tri100_3.X.Data;
        y = tri100_3.Y(1).Data;
        u = tri100_3.Y(3).Data;
        y_delay = tri100_3.Y(2).Data;
        
    case 16
        load tri50_1;
        FREQ = 5;
        t = tri50_1.X.Data;
        y = tri50_1.Y(1).Data;
        u = tri50_1.Y(3).Data;
        y_delay = tri50_1.Y(2).Data;
        
    case 17
        load tri50_2;
        FREQ = 5;
        t = tri50_2.X.Data;
        y = tri50_2.Y(1).Data;
        u = tri50_2.Y(3).Data;
        y_delay = tri50_2.Y(2).Data;
        
    case 18
        load tri50_3;
        FREQ = 5;
        t = tri50_3.X.Data;
        y = tri50_3.Y(1).Data;
        u = tri50_3.Y(3).Data;
        y_delay = tri50_3.Y(2).Data;
    
end

%The first 0.1 second of the measurement was added to remove vibrations
%from the piezo.
diff = length(t) - signal_length;
%Ts = t(2)-t(1);
t = t(diff:end-1)-(Ts*diff-Ts);


u = u(diff:end-1);
y = y(diff:end-1);
y_delay = y_delay(diff:end-1);

switch reference_signal
    case 1 % rising sine input
        NumOfCycles = 5;
        % FREQ = 40;
        t = 0:Ts:NumOfCycles/FREQ-Ts;
        gain = linspace(0,2.5,length(t));
        y_ref = -(0.5+gain).*cos(2*pi*FREQ*t);
        
    case 2 %sine with amp2 input
        NumOfCycles = 50;
        % FREQ = 40;
        t = 0:Ts:NumOfCycles/FREQ-Ts;
        y_ref = 2.*sin(2*pi*FREQ*t)';
        
end

%Remove some of the waves for better illustration:
NumOfWaves = 5;
Remove_waves = NumOfCycles-NumOfWaves;
if Remove_waves > 0
    t = t((Remove_waves/FREQ)/Ts:end-1)-(Ts*length(t(1:(Remove_waves/FREQ)/Ts))-Ts);
    u = u((Remove_waves/FREQ)/Ts:end-1);
    y = y((Remove_waves/FREQ)/Ts:end-1);
    y_delay = y_delay((Remove_waves/FREQ)/Ts:end-1);
    y_ref = y_ref((Remove_waves/FREQ)/Ts:end-1);
end

y_ref = y_ref+mean(y-y_ref);
diff = y-y_ref;
% diff = detrend(diff,'constant');
%Compare the square error
error = sum((diff).^2)

figure(1);clf(1);
plot(t,u);
grid on;
xlabel('Time [s]');
ylabel('Input Voltage [V]');

figure(2);clf(2);
plot(t,y);
grid on;
xlabel('Time [s]');
ylabel('Measured Output Voltage [V]');

% y_ref = y_ref(1:9800);
% y = y(1:9800);
% diff = diff(1:9800);
% t = t(1:9800);
figure(3);clf(3);
[AX,H1,H2] = plotyy(t,5*[y_ref;y],t,5*diff);
% plot(t,y*5,'r',t,5*y_ref,'k',t,5*diff,'b');
grid on;
%axis([0,t(end) 1.1*min([min(Y),min(y)]) 1.1*max([max(Y),max(y)])]);
% title('Fitted and measured output');
% ylabel('Voltage [V]');
legend('Reference','Measurement','Error');
xlabel('Time [s]');  
ylabel('Voltage [V]');
% xlim([t(1) t(9800)]);
axes(AX(1))
set(AX(1),'YLim',[1.1*min(5*[y,y_ref]),-1.1*min(5*[y,y_ref])]);
set(AX(1),'YTick',-21:3:21)
ylabel('Displacement [\mum]');
axes(AX(2));
ylabel('Error [\mum]');      
set(AX(2),'ycolor','k') 
%set(H2,'LineStyle',':')
set(H2,'Color','blue','LineWidth',2,'LineStyle',':')
set(H1(1),'Color','black','LineWidth',2)
set(H1(2),'Color','red','LineWidth',2,'LineStyle','--')
set(AX(2),'YLim',[1.1*min(5*[y,y_ref]),-1.1*min(5*[y,y_ref])]*(3.5/21));
set(AX(2),'YTick',-3.5:0.5:3.5)


% hold on;
% plot(t,5*y_ref,'LineWidth',2)
% plot(t,5*y,'r');
% hold on;
% %plot(t,y_ref,'LineWidth',2);
% legend('reference','measurement','Location','NorthWest');
% xlabel('Time [s]');
% ylabel('Displacement [\mum]');
% grid on;
% axis([min(t) max(t) 1.1*min([5*y_ref,5*y]) 1.1*max([5*y_ref,5*y])]);
return;

figure(4);clf(4)
plot(t,5*(y-y_ref));
xlabel('Time [s]');
ylabel('Displacement Error [\mum]');
grid on;

figure(5);clf(5);
plot(5*y_ref,5*y);
hold on;
grid on;
xlabel('Reference Input Displacement [\mum]');
ylabel('Measured Output Displacement [\mum]');
axis(1.1*[min(5*y_ref) max(5*y_ref) min(5*y) max(5*y)]);
%legend('Reference Freq = 20Hz','Reference Freq = 40Hz','Reference Freq = 100Hz','Location','NorthWest');
%legend('Without Time Delay','With Time Delay','Reference Freq = 100Hz','Location','NorthWest');
% end

figure(6);clf(6);
plot(t,5*y_ref,'Linewidth',2);
grid on;
xlabel('Time [s]');
ylabel('Dispaclement [\mum]');