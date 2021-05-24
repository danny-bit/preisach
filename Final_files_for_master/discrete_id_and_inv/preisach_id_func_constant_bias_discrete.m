function [ F ] = preisach_id_func_constant_bias( par,Y,t,RA)
%PREISACH_ID_FUNC_CONSTANT_BIAS Summary of this function goes here
%   Detailed explanation goes here

% global RA first
% 
% if isempty(first)
%     first = 1;
%     RA = cont_preisach(x,t,pgrid,N,A);
% end

d = par;
Q = length(RA(1,:));
%disp(num2str(size(par)));
disp(num2str(d));
mu = lsqnonneg(RA,Y-d);

% N = (-1+sqrt(1+8*Q))/2;
% mu(N) = 0;

y = zeros(1,length(t));
for i = 1:length(t)
    %y(i) = RA(i,:)*mu +d;
    yi = 0;
    for j = 1:Q
        yi = yi + mu(j)*RA(i,j);
    end
    y(i) = yi + d;
end

F = y'-Y;


end

