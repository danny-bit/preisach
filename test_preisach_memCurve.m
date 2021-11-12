% interactive example
clear test_preisach_memCurve_callback


f = figure('Color','w');
ax = subplot(211);
ax2 = subplot(212);

b = uicontrol('Parent',f,'Style','slider','Position',[0,0,419,23],...
              'value',0, 'min',0, 'max',1000,'SliderStep', [10, 10] / (1000 - 0));
          
b.Callback = @(es,ed) test_preisach_memCurve_callback(es.Value,ax,ax2) ;

