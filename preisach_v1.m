function [y, gamma] = preisach_v1(u, gamma, mu)
% preisach_v1 ... straight-forward impelementation of the 
% preisach hysteresis model
%
% notes:
% - high computational complexity: recalculation of every hysteron in every tick
% - could also be interpreted as the calculation of a grid based memory curve
%
% inputs:
% u (1,1) ... input
% gamma (N,3) ... triples describing the hysteron grid
%                 [(alpha_k, beta_k, hysteron_alpha/beta_state)]
% mu(N,1) ... hysteron weighting function     
%             TBD consider: mu as a function with mu(alpha,beta) 
%                           e.g. a distribution
%
% outputs:
% y (1,1) ... output
% gamma (N,3) ... state update gamma (see input description)

%% core
    
    N_hysterons = size(gamma,1);
    
    for k_hysteron= 1:N_hysterons
        % update hysteron state
        alpha_k = gamma(k_hysteron,1);
        beta_k = gamma(k_hysteron,2);
        state_k = gamma(k_hysteron,3);
        
        % NOTE: other hysteresis functions would also be possible
        gamma(k_hysteron,3) = hyst_relay(u,state_k, alpha_k,beta_k);
    end
    
    % apply weighting function
    y = mu'*gamma(:,3);
end