function memory_curve_out = hyst_callback (u,ax)

persistent memory_curve
    alpha0 = 10;
    beta0  = -2;
if (isempty(memory_curve))

    memory_curve = [alpha0,beta0;
                    beta0,beta0];
            
end
memory_curve = update_memory_curve(u,memory_curve);
memory_curve_out = memory_curve;
cla(ax); 
plot(ax,memory_curve(:,2),memory_curve(:,1)); hold on;
plot(ax,[beta0, alpha0],[beta0, alpha0],'--k')


ylim(ax,[-3,11])
xlim(ax,[-3,11])
grid on