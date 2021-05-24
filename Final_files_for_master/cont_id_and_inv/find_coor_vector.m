function [ out ] = find_coor_vector( maxmin_coor, pgrid )
%FIND_COOR_VECTOR Summary of this function goes here
%   Detailed explanation goes here

maxmin_coor = maxmin_coor'; %faster to read each column first.
out = zeros(size(maxmin_coor));
for i=1:2
    for j=1:length(maxmin_coor(:,1))
        [c, out(j,i)] = min(abs(maxmin_coor(j,i)-pgrid));
    end
end

out = out';

