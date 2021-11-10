function memory_curve_out = hyst_callback (u,ax,ax2)

persistent memory_curve
persistent pointsY pointsU

memory_curve = update_memory_curve(u,[-2 10],memory_curve);
memory_curve_out = memory_curve;    
cla(ax); hold(ax,'on');
plot(ax,memory_curve(:,2),memory_curve(:,1),'x-'); 
plot(ax,[-2, -2, 10,-2],[-2, 10, 10,-2],'-k')



[X,Y] = meshgrid(linspace(-2,10,5), ...
                 linspace(-2,10,5));
plot(ax, X(:),Y(:),'x')

% O2 valve (0-1000)
% define values of GRID 
% e.g. by HW test or artificially by integration of a density?
grid_FORC.X = X;
grid_FORC.Y = Y;
grid_FORC.Vals = 10*X.*Y;

pointsU(end+1) = u;
pointsY(end+1) = output_memory_curve(memory_curve,grid_FORC);
cla(ax2);
plot(ax2,pointsU,pointsY)

ylim(ax,[-3,11])
xlim(ax,[-3,11])
grid(ax,'on')
grid(ax2,'on')
ylim(ax2,'auto')
xlim(ax2,'auto')

