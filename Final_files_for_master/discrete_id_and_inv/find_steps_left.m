function [ t_steps,u_steps ] = find_steps_left( t,u )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here


step_points = zeros(2,1000);
k = 0;
for i=1:length(u)
    if(i == 1)
        k=k+1;
        step_points(:,k) = [t(i);u(i)];
    else
        if(u(i) ~= u(i-1))
        k=k+1;
        step_points(:,k) = [t(i);u(i)];
        end
    end
end
step_points(:,k+1:end) = [];

t_steps = step_points(1,:);
u_steps = step_points(2,:);

end

