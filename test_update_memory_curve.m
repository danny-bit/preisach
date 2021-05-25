alpha0 = 10;
beta0  = -2;
memory_curve = [alpha0,beta0;
                beta0,beta0];
            
figure; hold on;
plot(beta0:0.01:alpha0,beta0:0.01:alpha0,'--k')
plot(memory_curve(:,2),memory_curve(:,1),'o-b')

memory_curve = update_memory_curve(8,memory_curve);
plot(memory_curve(:,2),memory_curve(:,1),'o-g')
disp(memory_curve);

memory_curve = update_memory_curve(-1,memory_curve);
plot(memory_curve(:,2),memory_curve(:,1),'x-r')


memory_curve = update_memory_curve(7,memory_curve);
plot(memory_curve(:,2),memory_curve(:,1),'x-k')

memory_curve = update_memory_curve(0,memory_curve);
plot(memory_curve(:,2),memory_curve(:,1),'x-c')


memory_curve = update_memory_curve(6,memory_curve);
plot(memory_curve(:,2),memory_curve(:,1),'x-k')

memory_curve = update_memory_curve(1,memory_curve);
plot(memory_curve(:,2),memory_curve(:,1),'x-c')

clear hyst_callback
f = figure;
ax = axes(f);
b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',[-5], 'min',-5, 'max',15);
b.Callback = @(es,ed) hyst_callback(es.Value,ax) ;

