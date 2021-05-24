function y = hyst_relay(u, x, alpha, beta)

    if (u>=alpha)
        y = 1;
    elseif u<=beta
        y = -1;
    else
        y = x;
    end
    
    % alternative formulation
    % 	y(t)=min[sign(x−β),max[y(t−),sign(x−α)]].