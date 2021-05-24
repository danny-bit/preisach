function [y, gamma_hat_out] = preisach_v1(u, gamma, mu)
% preisach_v1 ... straight-forward impelementation of the 
% preisach hysteresis model
%
% notes:
% - high computational complexity: recalculation of every hysteron in every 
%   timestep
% - could also be interpreted as the calculation of a grid based memory
%   memory curve
%
% inputs:
% u ... scalar input
% gamma (N,2) ... tuples describing the hysteron grid
%                 [(alpha_k, beta_k)]
% mu(N,1) ... hysteron weighting function     
%             TBD consider: mu as a function with mu(alpha,beta) 
%                           e.g. a distribution
%
% outputs:
% y ... scalar output
% 
% gamma_hat (N,1) ... hysteron states

%% core
    
    N_hysterons = size(gamma,1);
    
    % gamma_hat (N,1) ... hysteron state 
    persistent gamma_hat
    
    if (isempty(gamma_hat))
        % initialize hysteresis
        gamma_hat = zeros(N_hysterons,1);
    end
    
    for k_hysteron= 1:N_hysterons
        % update hysteron state
        alpha_k = gamma(k_hysteron,1);
        beta_k = gamma(k_hysteron,2);
        gamma_hat(k_hysteron) = hyst_relay(u,gamma_hat(k_hysteron),...
                                           alpha_k,beta_k);
    end
    
    % apply weighting function
    y = mu'*gamma_hat;
    gamma_hat_out = gamma_hat;
end