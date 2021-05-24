function [ OnOff_vector, OnOff_matrix ] = get_OnOff_vector(minmax_coor, minimum, maximum, isleft, pgrid, OnOff_vector, OnOff_matrix )
%GET_ONOFF_VECTOR Summary of this function goes here
%   Detailed explanation goes here

N = length(pgrid);
Q = (N*(N+1))/2;

% global OnOff_vector OnOff_matrix first_2
% 
% if isempty(first_2)
%     OnOff_vector = zeros(1,Q);
%     OnOff_matrix = zeros(N,N);
%     first_2 = 1;
% end
if (isempty(minimum) && isempty(maximum)) %Either all relays On or Off.
    if isleft
        OnOff_matrix = -1*ones(N,N);
    elseif isleft==0
        OnOff_matrix = ones(N,N);
    end
else %Some elements on, and some elements off.
    
    coordinates = find_coor_vector(minmax_coor,pgrid); %find the coordinates in pgrid corresponding to minmax_coor
    
    for j=2:length(coordinates(1,:))
        if isleft
            if j==2 && coordinates(2,1) < length(pgrid) %if the first coordinate line and the first y-coordinate is not at the maximum level, then this part will be -1.
                OnOff_matrix(1:N-coordinates(2,j-1),:) = -1;
            end
            if coordinates(1,j) > coordinates(1,j-1) %edge to the right in the memory curve
                OnOff_matrix(N:-1:(N+1)-(coordinates(1,j)-1),coordinates(1,j-1):coordinates(1,j)-1) = 1;
            elseif coordinates(2,j) < coordinates(2,j-1) %edge down in the memory curve
                OnOff_matrix(N+1-coordinates(2,j-1):N-coordinates(2,j),coordinates(1,j)+1:end) = -1;
            end
        elseif isleft == 0
            if j==2 && coordinates(1,j) > 1
                OnOff_matrix(:,1:(coordinates(1,j)-1)) = 1;
            end
            if coordinates(2,j) < coordinates(2,j-1) %edge down in the memory curve
                OnOff_matrix(N+1-coordinates(2,j-1):N-coordinates(2,j),coordinates(1,j)+1:end) = -1;
            elseif coordinates(1,j) > coordinates(1,j-1) %edge to the right in the memory curve
                OnOff_matrix(N:-1:(N+1)-(coordinates(2,j)-1),coordinates(1,j-1):coordinates(1,j)-1) = 1;
            end
        end
    end
    


    
    edge_vector = find_edge_vector(coordinates); %calculate the edge vector, that is the coordinates of the relays where the memory curve go through.
    area_vector = area_operator(edge_vector,minmax_coor,pgrid);
    
    for j=1:length(edge_vector(1,:))
        %[R_,OnOff_matrix(N+1-edge_vector(2,j),edge_vector(1,j))] = relay_operator(pgrid(edge_vector(2,j)),pgrid(edge_vector(1,j)),OnOff_matrix_last(N+1-edge_vector(2,j),edge_vector(1,j)),x(i));
        OnOff_matrix(N+1-edge_vector(2,j),edge_vector(1,j)) = area_vector(j);
    end
    
end

%reset the elemtens below the diagonal in the Presiach plane
resetMatrix = ones(N,N);
for j = 2:length(pgrid)
    resetMatrix(j,(length(pgrid)):-1:(length(pgrid)-(j-2))) = 0;
end
OnOff_matrix = OnOff_matrix.*resetMatrix;
k=0;
for j = 1:N
    for p = j:N
        k=k+1;
        OnOff_vector(k) = OnOff_matrix((N+1)-p,j);
    end
end

%OnOff_vector_out = OnOff_vector;

end

