function test_preisach_memCurve_callback (u,ax,ax2)

persistent memory_curve
persistent pointsY pointsU
uRange = [0 1000];

%% update hysteresis
% bellavista O2 valve -> use mirrored values to avoid interpolation 
% problems
load('100Mat_mirror')

% update hysteresis
memory_curve = preisach_memCurve_update(u,uRange,memory_curve);
y_out = preisach_memCurve_output(memory_curve,grid_FORC);

memory_curve_out = memory_curve;    

%% plotting
cla(ax); hold(ax,'on');
plot(ax,memory_curve(:,2),memory_curve(:,1),'x-'); 

x2 = [uRange(1); memory_curve(:,2)];
y2 = [uRange(1); memory_curve(:,1)];
patch(ax, x2,y2,'blue','FaceAlpha',.3)

plot(ax,[uRange(1), uRange(1), uRange(2), uRange(1)], ...
        [uRange(1), uRange(2), uRange(2), uRange(1)],'-k','Linewidth',2)


xlabel(ax, 'beta')
ylabel(ax, 'alpha')

[X,Y] = meshgrid(linspace(uRange(1),uRange(2),20), ...
                 linspace(uRange(1),uRange(2),20));
plot(ax, X(:),Y(:),'x')

pointsU(end+1) = u;
pointsY(end+1) = y_out;
cla(ax2);
plot(ax2,pointsU,pointsY)

ylim(ax,[0,1000])
xlim(ax,[0,1000])
grid(ax,'on')
grid(ax2,'on')
ylim(ax2,'auto')
xlim(ax2,[200 900])

