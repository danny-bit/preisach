
clear all;
% close all;
tic
%Choose what data to use
choose_mudata = 3;
switch choose_mudata
    case 1
        load mudata_20hz_lp;
    case 2
        load mudata_20hz_NO_LP_delay;
    case 3
        load mudata_20hz_NO_LP_NO_delay;
end

%mu(99) = 0;

choose_input = 3;
downsample_nr =1;
switch choose_input
    case 1
        load 20_hz_lp;
        t = hz_lp.X.Data';
        Y = hz_lp.Y(1).Data';
        x = hz_lp.Y(3).Data';
    case 2
        load 40_hz_lp;
        t = hz_lp.X.Data';
        Y = hz_lp.Y(1).Data';
        x = hz_lp.Y(3).Data';
    case 3
        load 100_hz_lp;
        t = hz_lp.X.Data';
        Y = hz_lp.Y(1).Data';
        x = hz_lp.Y(3).Data';
    case 4
        load 20_hz_no_lp;
        t = hz_no_lp.X.Data';
        Y = hz_no_lp.Y(1).Data';
        x = hz_no_lp.Y(3).Data';
    case 5
        load 40_hz_no_lp;
        t = hz_no_lp.X.Data';
        Y = hz_no_lp.Y(1).Data';
        x = hz_no_lp.Y(3).Data';
    case 6
        load 100_hz_no_lp;
        t = hz_no_lp.X.Data';
        Y = hz_no_lp.Y(1).Data';
        x = hz_no_lp.Y(3).Data';
    case 7
        load no_lp_20;
        t = no_lp_20.X.Data';
        Y = no_lp_20.Y(2).Data';
        x = no_lp_20.Y(3).Data';
    case 8
        load no_lp_40;
        t = no_lp_40.X.Data';
        Y = no_lp_40.Y(2).Data';
        x = no_lp_40.Y(3).Data';
    case 9
        load no_lp_100;
        t = no_lp_100.X.Data';
        Y = no_lp_100.Y(2).Data';
        x = no_lp_100.Y(3).Data';
end

t = t(15001:end-1)-(1.5-1e-5);
x = x(15001:end-1);
Y = Y(15001:end-1);

t = decimate(t,downsample_nr);
Y = decimate(Y,downsample_nr);
x = decimate(x,downsample_nr);

y = id_model_cont(mu,t,N,alpha,beta,x,A,d,RA);

toc
time1 = (length(t)/50)*20;
time2 = (length(t)/50)*21;
y = y(time1:time2);
Y = Y(time1:time2);
x = x(time1:time2);
t = t(time1:time2)-(t(time1)-1e-4);

Y = Y+mean(y-Y);
error = y-Y;
%diff = y-Y;

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

figure(2);%clf(2);


maxvalue = 1.1*max(error);
if maxvalue <0
    maxvalue = maxvalue+0.3*abs(maxvalue);
end
% [AX,H1,H2] = plotyy(t,5*[y,Y],t,error);
%plot(t,y,'r',t,Y,'g',t,error,'b');
hold on;
plot(t,5*y,'k','LineWidth',2);
plot(t,5*Y,'b','LineWidth',2);
grid on;
axis([0,t(end) 1.1*min(5*[min(Y),min(y)]) 1.1*max(5*[max(Y),max(y)])]);
% title('Fitted and measured output');
% ylabel('Voltage [V]');
legend('Model Response Delay','Measured Response Delay','Measured Response No Delay','Measured Response 100 Hz','Location','South');
xlabel('Time [s]');  
ylabel('Displacement [\mum]');
% axes(AX(1))
% set(AX(1),'YLim',[1.1*min(5*[y;Y]),-1.1*min(5*[y;Y])]);
% xlim([t(1) t(end)]);
% set(AX(1),'YTick',-21:3:21)
% ylabel('Displacement [\mum]');
% axes(AX(2));
% xlim([t(1) t(end)]);
% ylabel('Error [\mum]');      
% set(AX(2),'ycolor','k') 
% %set(H2,'LineStyle',':')
% set(H2,'Color','blue','LineWidth',2,'LineStyle',':')
% set(H1(1),'Color','black','LineWidth',2)
% set(H1(2),'Color','red','LineWidth',2,'LineStyle','--')
% set(AX(2),'YLim',[-4,4]);
% set(AX(2),'YTick',-4:1:4)


% 
% 
% error = y-Y;
% figure(3);clf(3);
% plot(t,error);
% grid on;
% maxvalue = 1.1*max(error);
% if maxvalue <0
%     maxvalue = maxvalue+0.3*abs(maxvalue);
% end
% axis([0,t(end) -1.1*abs(min(error)) maxvalue]);
% %title('Error in voltage');
% ylabel('Voltage error [V]');
% xlabel('Time [s]');     

figure(3);clf(3);
hold on;
plot(t,x);
grid on;
axis([0 t(end) 1.1*min(x) 1.1*max(x)]);
ylabel('Input voltage [V]');
xlabel('time [s]');

figure(4);%clf(4);
% plot(y,Y,'Color',[0 0.5 0],'LineWidth',2,'LineStyle','-.')
plot(y,Y,'b','LineWidth',2);
%plot(y,Y,'Color',[0 0.5 0],'LineWidth',2);
axis(1.1*[min(y) max(y) min(Y) max(Y)]);
grid on;
hold on
xlabel('Model Displacement [\mum]');
ylabel('Measured Displacement [\mum]');
% legend('Time Delayed Signal','Not Time Delayed Signal','Response 100 Hz','Location','SouthEast');
legend('Response 20 Hz','Response 40 Hz','Response 100 Hz','Location','SouthEast');
axis(1.1*[min(Y) max(Y) min(y) max(y)]); 