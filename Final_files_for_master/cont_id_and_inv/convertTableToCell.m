function [ cell ] = convertTableToCell( table )
%CONVERTTABLETOCELL Summary of this function goes here
%   Detailed explanation goes here

    n = length(table);
    for i=1:n;
        cell(i) = {table(i)};
    end


end

