%% interactive example
clear test_preisach_simple_callback

f = figure('Color','w');
ax = subplot(211);
ax2 = subplot(212);

b = uicontrol('Parent',f,'Style','slider','Position',[0,0,419,23],...
              'value',0, 'min',0, 'max',10);
          
b.Callback = @(es,ed) test_preisach_simple_callback(es.Value,ax,ax2) ;

