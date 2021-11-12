function y = preisach_memCurve_output(memory_curve,grid)
%%  y = preisach_memCurve_output(memory_curve,grid)
% calculate output of hysteresis, given the memory curve and a grid of the
% first order reversal output values
%
% inputs:
% memory_curve (:,2) ... matrix of vertices of memory curve (alpha_k,beta_k)
% grid               ... struct containing the first order reversal output
%                        values
%                        grid.alpha, grid.beta, grid.f

%%
    y = -grid.f(end,end)/2*0;

    Nmemory = length(memory_curve);
    %memory_curve
    
    for k=2:2:length(memory_curve)
        % take only horizontally connected points (trapezoids)
        Qk = everet(memory_curve(k-1,1),memory_curve(k-1,2))-...
             everet(memory_curve(k,1),memory_curve(k,2));
           
        y = y +  2*Qk;
    end

    function out = everet (alpha,beta)
        out = 0.5*(myInterp2(alpha,alpha)-...%alpha,0 , nearest
                   myInterp2(alpha,beta));
    end

    function val = myInterp2(alpha,beta)
        alpha=max(alpha-30,0);
        beta=max(beta-30,0);
        val = interp2(grid.alpha,grid.beta,grid.f,alpha,beta,'linear');
    end
end