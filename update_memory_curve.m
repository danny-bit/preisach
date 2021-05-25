function memory_curve = update_memory_curve (u, memory_curve)
%  memory_curve = update_memory_curve (u, memory_curve)
%
% inputs:
% u ... current input
% memory_curve (N,2) ... points on the memory curve (alpha_k,beta_k)
%                        - memory_curve(1,:) must contain (alpha_0,beta_0)
%                        - points must form a staircase (tuples of
%                          consecutive points mast have a common element)
%                        - memory_curve(end,:) must be a point on the
%                          hypothenuse (val,val)

%% core

    % hysteresis major loop / triangle limits
    alpha0 = memory_curve(1,1);
    beta0  = memory_curve(1,2);

    % noise supression: detect increasing / decreasing with a limit
    delta_min = 10^-5; 
    
    % last input must be point on triangle
    u_minus = memory_curve(end,2);
    
    % limit input to hyteresis limits
    u = max(min(u,alpha0),beta0);
    
    if ((u - u_minus) > delta_min)
        % increasing -> update alpha values
        
         if (u>=memory_curve(1,1))
             % new maximum -> delete history
             memory_curve = [u, beta0;
                             u,u];
             return
         end
        
        % whipeout propery -> erase all below
        err = u-memory_curve(:,1);
        memory_curve(err>=0,:) = [];
        
        % connect new point (u,u) with staircase to memory curve
        memory_curve(end+1, :) = [u, memory_curve(end,2)];
        memory_curve(end+1, :) = [u,u];
        
    elseif (-(u - u_minus) > delta_min)
        % decreasing -> update beta values
        
         if (u<=memory_curve(1,2))
            % new minimum -> delete history
            memory_curve = [alpha0,u;
                            u,u];
            return
         end
        
        % whipeout propery -> erase all points to the right of u
        err = memory_curve(:,2)-u;
        memory_curve(err>=0,:) = [];
        
        % connect new point (u,u) with staircase to memory curve
        memory_curve(end+1, :) = [memory_curve(end,1),u];
        memory_curve(end+1, :) = [u,u];
    end
end