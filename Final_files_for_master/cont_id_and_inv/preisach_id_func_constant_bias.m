function [ F ] = preisach_id_func_constant_bias( par,Y,t,x,N,A,pgrid,RA)
%PREISACH_ID_FUNC_CONSTANT_BIAS Summary of this function goes here
%   Detailed explanation goes here

% global RA first
% 
% if isempty(first)
%     first = 1;
%     RA = cont_preisach(x,t,pgrid,N,A);
% end

d = par;

mu = lsqnonneg(RA,Y-d);
disp(num2str(par));
y = zeros(1,length(t));
for i = 1:length(t)
    y(i) = RA(i,:)*mu +d;
end

F = y'-Y;

end

