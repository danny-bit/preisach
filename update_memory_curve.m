function memory_curve = update_memory_curve (u, uRange, memory_curve)
%  memory_curve = update_memory_curve (u, memory_curve)
%
% inputs:
% u      ... current input
% uRange ... range of the input [uMin, uMax]
% memory_curve (:,2) ... list of vertices of memory curve (alpha_k,beta_k)
%                     - memory_curve(1,:) be on left side of triangle
%                     - points must form a staircase (tuples of
%                       consecutive points must have a common element)
%                     - memory_curve(end,:) must be a point on the
%                       hypothenuse of the triangle (alpha,beta), with
%                       alpha = beta

%% prepare

    % hysteresis major loop / triangle limits
    uMin = uRange(1);
    uMax  = uRange(2);

    % noise supression: detect increasing / decreasing with a limit
    deltaU_min = 10^-5; 
    
    % initialize
    if (isempty(memory_curve))
        memory_curve = uMin*ones(2,2);
    end
    
    % get previous input (point on hypothenuse)
    u_prev = memory_curve(end,2);
    
%% main functionality    

    % handle maximum/minimum edge case
    if (u>=uMax)
        memory_curve = [uMax, uMin;
                        uMax, uMax];
        return
    elseif (u<=uMin)
        memory_curve = [uMin, uMin;
                        uMin, uMin];
        return
    end
    
    if ((u - u_prev) > deltaU_min)
        direction = 1; % increasing
    elseif (-(u - u_prev) > deltaU_min) 
        direction = -1; % decreasing
    else
        return
    end
    
    if (direction == 1)
        % increasing; "update alpha values"

        % whipeout propery 
        % -> erase all below and on "horizontal" input line
        err = u-memory_curve(:,1);
        memory_curve(err>=0,:) = [];

        % connect new point (u,u) to memory curve by staircase
        if (isempty(memory_curve))
            % boundary case
            memory_curve(end+1, :) = [u, uMin];
        else
            memory_curve(end+1, :) = [u, memory_curve(end,2)];
        end
        memory_curve(end+1, :) = [u,u];
        
    elseif (direction == -1)
        % decreasing; "update beta values"
        
        % whipeout propery 
        % -> erase all points to the right and on  "vertical" input line
        err = memory_curve(:,2)-u;
        memory_curve(err>=0,:) = [];
        
        % connect new point (u,u) to memory curve by staircase
        if (isempty(memory_curve))
            % boundary case
            memory_curve(end+1, :) = [uMax, u];
        else
            memory_curve(end+1, :) = [memory_curve(end,1),u];
        end
        memory_curve(end+1, :) = [u,u];
    end
end