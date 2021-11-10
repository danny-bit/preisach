function y = hyst_relay(u, x, alpha, beta)
% hyst_relay ... hysterion with relay function 
% 
%
% u ... input
% x ... hysteron state
% alpha ... hysteron values
% beta ... hysteron values

%%

    if (u>=alpha)
        y = 1;
    elseif u<=beta
        y = -1;
    else
        y = x;
    end
