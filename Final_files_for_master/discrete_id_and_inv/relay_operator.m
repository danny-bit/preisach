function [ y,S ] = relay_operator( alpha,beta,s,x,h )
%RELAY_OPERATOR Output of a delayed relay operator
switch s
    case -1
        if x > alpha + (h/2)
            y =1;
            S =1;
        else
            y = -1;
            S = -1;
        end
    case 1
        if x < beta - (h/2)
            y = -1;
            S = -1;
        else
            y = 1;
            S = 1;
        end
end

