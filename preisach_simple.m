function [y, gamma] = preisach_simple(u, gamma, mu)
%% preisach_simple ... straight-forward impelementation of the 
% preisach hysteresis model
%
% - high computational complexity: re-calculation of every hysteron in every tick
%
% inputs:
% u (1,1)     ... input
% gamma (N,3) ... triples describing the hysteron grid (state)
%                 [(alpha_k, beta_k, hysteron_state)]
%                 TBD consider as a list of functions
% mu(N,1)     ... hysteron weighting function
%                 TBD consider: mu as a function with mu(alpha,beta) 
%
% outputs:
% y (1,1)     ... output
% gamma (N,3) ... updated state

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