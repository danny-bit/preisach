function [ edge_vector ] = find_edge_vector( coordinates )
%FIND_EDGE_VECTOR Summary of this function goes here
%   edge_vector consist of the coordinates of the all the hysterons which the
%   memory curve passes through. With other words, it finds the coordinates
%   for the hysterons between two corners of the memory curve.

edge_vector = zeros(2,100); %make a vector that is (hopefully) long enough
k=0;
for j = 2:length(coordinates)
    if coordinates(1,j) > coordinates(1,j-1)
        for p=coordinates(1,j-1):coordinates(1,j)-1
            k=k+1;
            edge_vector(:,k) = [p;coordinates(2,j-1)];
        end
    elseif coordinates(2,j) < coordinates(2,j-1)
        for p=coordinates(2,j-1):-1:coordinates(2,j)+1
            k=k+1;
            edge_vector(:,k) = [coordinates(1,j-1);p];
        end
    end
    if j==length(coordinates(1,:))
        k=k+1;
        edge_vector(:,k) = [coordinates(1,j);coordinates(2,j)];
        edge_vector(:,k+1:end) = [];
    end
end

end

