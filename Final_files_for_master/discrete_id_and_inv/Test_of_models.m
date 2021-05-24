
clear all;
close all;
tic
%Choose what data to use
choose_mudata = 3;
switch choose_mudata
    case 1
        load mu_rising_sine_20hz_100_disc_N50;
    case 2
        load mu_rising_sine_20hz_100_disc_N20
    case 3
        load mu_smallsine_disc;
%         mu(49) = 0;
%         mu(50) = 0.04;
end

%N = length(pgrid(1,:));

choose_input = 2;
    
switch choose_input
    case 1
        load rising_sine_20hz_100;
        t = rising_sine_20hz_100.X.Data';
        Y = rising_sine_20hz_100.Y(1).Data';
        x = rising_sine_20hz_100.Y(3).Data';
        
        t = decimate(t,100);
        Y = decimate(Y,100);
        x = decimate(x,100);
        
        y = output_disc_model(mu,t,N,alpha,beta,x,A,d);
        
    case 2
        load bigsine;
        t = bigsine.X.Data';
        Y = bigsine.Y(1).Data';
        x = bigsine.Y(3).Data';
        
         
        
        t = t(15001:end-1)-(0.15-1e-5);
        x = x(15001:end-1);
        Y = Y(15001:end-1);
        
        t = decimate(t,100);
        Y = decimate(Y,100);
        x = decimate(x,100);

        y = output_disc_model(mu,t,N,alpha,beta,x,A,d);
    case 3
        load smallsine;
        t = smallsine.X.Data';
        Y = smallsine.Y(1).Data';
        x = smallsine.Y(3).Data';
        
        t = t(15001:end-1)-(0.15-1e-5);
        x = x(15001:end-1);
        Y = Y(15001:end-1);
        
        t = decimate(t,100);
        Y = decimate(Y,100);
        x = decimate(x,100);
        
        y = output_disc_model(mu,t,N,alpha,beta,x,A,d);
end
toc

Y = detrend(Y,'Constant');
x = detrend(x,'Constant'); 
y = detrend(y,'Constant');    

mu(2) = 0;
distribution = zeros(N,N);
k = 0;
for i = N:-1:1
    for j = i:-1:1
        k = k+1;
        distribution(i,j)= mu(k);
    end
end

figure(1);clf(1);
%         surf(pgrid,pgrid,distribution);
%         axis([-5.5 5.5 -5.5 5.5 0 0.3]);
bar3(distribution,1);
axis([0.5 length(distribution(1,:))+0.5 0.5 length(distribution(1,:))+0.5 0 1.1*max(max(distribution))]); 
%+-0.5 since the bar width is 1
set(gca,'XTick',1:((length(pgrid)-1)/5):length(pgrid));
set(gca,'YTick',1:((length(pgrid)-1)/5):length(pgrid));
labelcell = convertTableToCell(pgrid(end):(pgrid(1)-pgrid(end))/5:pgrid(1));
set(gca,'XTickLabel',labelcell);
set(gca,'YTickLabel',labelcell);
xlabel('\alpha');
ylabel('\beta');
zlabel('Distribution');

Y = Y+mean(y-Y);
% diff = y-Y;

figure(2);clf(2);
error = y-Y;
maxvalue = 1.1*max(error);
if maxvalue <0
    maxvalue = maxvalue+0.3*abs(maxvalue);
end
%[AX,H1,H2] = plotyy(t,[y,Y],t,error);
plot(t(end-68:end),5*y(end-68:end),'r',t(end-68:end),5*Y(end-68:end),'k',t(end-68:end),-5*error(end-68:end),'b','LineWidth',2);
grid on;
axis([t(end-68),t(end) 5.5*min([min(Y(end-68:end));min(y(end-68:end))]), 5.5*max([max(Y(end-68:end));max(y(end-68:end))])]);
% title('Fitted and measured output');
% ylabel('Voltage [V]');
legend('Model Output','Measurement','Error');
xlabel('Time [s]');  
ylabel('Displacement [\mum]');

figure(3);clf(3);
plot(t,x);
grid on;
axis([0 t(end) 1.1*min(x) 1.1*max(x)]);
ylabel('Input voltage [V]');
xlabel('time [s]');

figure(4);clf(4);
grid on;
plot(x,Y,x,y);