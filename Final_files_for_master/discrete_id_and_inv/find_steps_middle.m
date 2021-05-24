function [ t_steps,u_steps ] = find_steps_middle( t,u )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

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

% if isempty(state)
%     error('State not found in dins_steps');
% end

step_points = zeros(2,1000);
k = 0;

for i=1:length(u)
    if(i == 1)
        %k=k+1;
        prev_point = i;
        %step_points(:,k) = [t(i);u(i)];
    elseif(i == length(t))
        k=k+1;
        i_middle = round((((i)-prev_point)/2)+(prev_point));
        step_points(:,k) = [t(i_middle);u(i_middle)];
    else
        if(u(i) ~= u(i-1))
        k=k+1;
        i_middle = round((((i-1)-prev_point)/2)+(prev_point));
        step_points(:,k) = [t(i_middle);u(i_middle)];
        prev_point = i;
        end
    end
end
step_points(:,k+1:end) = [];

t_steps = step_points(1,:);
u_steps = step_points(2,:);

end