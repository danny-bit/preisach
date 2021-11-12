load('20Mat')
% meshgrid style 
% cols of alpha = const.
% cols of beta  = additional values;
uRange = [0, 1000]
[X,Y] = meshgrid(linspace(uRange(1),uRange(2),20), ...
                 linspace(uRange(1),uRange(2),20));
grid_FORC.alpha = X;
grid_FORC.beta = Y;
matX=mat;
matX=matX-diag(diag(matX));
grid_FORC.f = mat'+matX

figure;
surf(grid_FORC.f)
xlabel('alpha')
ylabel('beta')
%%
load('100Mat1')
%grid_FORC.f(end,:)=grid_FORC.f(end-1,:)
%grid_FORC.f(end,end)=grid_FORC.f(end-1,end-1)
% grid_FORC.f(:,1) = 0
% save('100Mat1','grid_FORC')

matX=grid_FORC.f;
matX=matX-diag(diag(matX));
grid_FORC.f = grid_FORC.f'+matX
save('100Mat1','grid_FORC')
figure;
surf(grid_FORC.alpha, grid_FORC.beta, grid_FORC.f)
xlabel('alpha')
ylabel('beta')
interp2(grid_FORC.alpha,grid_FORC.beta,grid_FORC.f,598.4090,598.4090)
%%
uMin = grid_FORC.alpha(1,1);
yMin = grid_FORC.f(1,1);

figure; hold all;
subCurves=2;
subPoints=4;

Nalpha = size(grid_FORC.alpha,2);

for idxCol = 1:subCurves:Nalpha
    
    rng = 1:subPoints:idxCol;
    if (rng(end) ~= idxCol)
        rng(end+1)=idxCol;
    end
    curveX = [uMin; grid_FORC.beta(rng,idxCol)];
    curveY = [yMin; grid_FORC.f(rng,idxCol)];
    
    plot(curveX,curveY,'-x')
end

rng = 1:1:Nalpha;
if (rng(end) ~= Nalpha)
	rng(end+1)=Nalpha;
end

vals = diag(grid_FORC.f);
plot(grid_FORC.alpha(end,rng),vals(rng),'k-x','LineWidth',1)

%%
