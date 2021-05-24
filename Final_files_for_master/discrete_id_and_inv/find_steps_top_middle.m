function [ t_steps,u_steps ] = find_steps_top_middle( t,u )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here




step_points = zeros(3,1000);
k = 0;
for i=1:length(u)
    if(i == 1)
        k=k+1;
        step_points(:,k) = [t(i);u(i);i];
    else
        if(u(i) ~= u(i-1))
            if (k >= 2) %test if a maximum or minimum, add the middle point as a interpolation point.
                if ((u(i) < step_points(2,k) && step_points(2,k) > step_points(2,k-1)) || (u(i) > step_points(2,k) && step_points(2,k) < step_points(2,k-1)))
                    k=k+1;
                    i_middle = round(step_points(3,k-1) + ((i-1)-step_points(3,k-1))/2);
                    step_points(:,k) = [t(i_middle);u(i_middle);i_middle];
                end
            end
        k=k+1;
        step_points(:,k) = [t(i);u(i);i];
        end
    end
end
step_points(:,k+1:end) = [];

t_steps = step_points(1,:);
u_steps = step_points(2,:);







% found_state = 0;
% state = []; %1=up, 0 = down
% j = 0;
% while ~found_state
%     j=j+1;
%     if (u(j+1) ~= u(j))
%         if(u(j+1) > u(j))
%             state = 1;
%             found_state = 1;
%         elseif u(j+1) < u(j)
%             state = 0;
%             found_state = 1;
%         end
%     end
% end
% 
% if isempty(state)
%     error('State not found in dins_steps');
% end
% 
% step_points = zeros(2,1000);
% k = 0;
% for i=1:length(u)
%     if(i == 1)
%         k=k+1;
%         step_points(:,k) = [t(i);u(i)];
%     else
%         if(u(i) ~= u(i-1))
%             if (state == 1)%up
%                 if(u(i) > u(i-1))
%                     k=k+1;
%                     step_points(:,k) = [t(i);u(i)];
%                 elseif( u(i) < u(i-1))
%                     k=k+1;
%                     step_points(:,k) = [t(i-1);u(i-1)];
%                     state = 0;
%                 end
%             elseif (state == 0) %down
%                 if (u(i) < u(i-1))
%                     k=k+1;
%                     step_points(:,k) = [t(i-1);u(i-1)];
%                 elseif (u(i) > u(i-1))
%                     k=k+1;
%                     step_points(:,k) = [t(i);u(i)];
%                     state = 1;
%                 end
%             end
%                 
%         end
%     end
% end
% step_points(:,k+1:end) = [];
% 
% t_steps = step_points(1,:);
% u_steps = step_points(2,:);

end

