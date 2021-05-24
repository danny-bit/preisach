function [ minmax_coor, isleft, min_vector, max_vector ] = get_minmax_vector( x,x_prev,pgrid,h,isleft, minimum, maximum)
%GET_MINMAX_VECTOR Summary of this function goes here
%   Detailed explanation goes here
h=h/2;
%the first input, must define if the input is a maximum or a minimum
if isnan(x_prev);
    if (isleft)
        maximum = x;
        minimum = [];
    else
        maximum = [];
        minimum = x;
    end
else
    if x == x_prev
        %do nothing;
    elseif x > x_prev %When there is an increasing input, the maximum value might be updated, depending on how large the input is compared to the previous inputs.
        if x >= pgrid(end)+h
            maximum = [];
            minimum = [];
            isleft = 0;
        elseif x <= pgrid(1)-h
            %do nothing, the input is increasing and out of bounds in the negative
            %region
        else
            index = find(maximum-x <= 0,1); %Finds the index of the first value in maximum which is lower than the input x(i)
            if(isempty(index))
                maximum(end+1) = x; %A input which is lower than the lowest maximum is added at the end of the maximum vector
            else
                if(index==1 && isleft==1)
                    minimum = []; %If the memory curve starts from the left and the input is higher than the previous maximum, then all minimums are deleted
                end
                maximum(index:end) = [];%Delete the lower maximums since they do not contribiute anymore.
                maximum(index) = x;
            end
        end
        test_cond = 0; % remove the last minimum if the new maximum removed the effect of it. Can remove multiple minimums.
        while test_cond == 0
            if ~isempty(minimum) && ( length(minimum) > length(maximum) || (length(minimum) == length(maximum) && isleft ==1)) %Then the last minimum is deleted due to a more positive maximum than the previous maximum. This is also true when the last local extremum was a maximum, the memory curve starts from the left and the lenght of minimum is equal to the length of maximum.
                minimum(end) = [];
            else
                test_cond = 1;
            end
        end
    elseif x < x_prev %When there is a decreasing input, the minimum value might be updated, depending on how negative the input is, compared to the previous inputs.
        if x <= pgrid(1)-h
            maximum = [];
            minimum = [];
            isleft = 1;
        elseif x >= pgrid(end)+h
            %do nothing, the input is decreasing and out of bounds in
            %the positive region
        else
            index = find(minimum-x >= 0,1); %Finds the index of the first value in minimum which is higher than the input x(i)
            if(isempty(index))
                minimum(end+1) = x; %A input which is higher than the last minimum is added to the end of the minimum vector
            else
                if(index==1 && isleft==0)
                    maximum = []; % If the memory curve starts from the top, and the input is lower than any previous inputs, than all maximums are deleted.
                end
                minimum(index:end) = []; %Delete the higher minimums since they do not controbiute anymore.
                minimum(index) = x;
            end
        end
        test_cond = 0; % remove the last maximum if the new maximum removed the effect of it. Can remove multiple maximums.
        while test_cond == 0
            if ~isempty(maximum) && (length(maximum) > length(minimum) || (length(maximum) == length(minimum) && isleft == 0)) %Then the last maximum is deleted due to a more negative minimum than the previous minimum. For second condition look at the correponding condition for x(i) > x(i-1)
                maximum(end) = [];
            else
                test_cond = 1;
            end
        end
    end
end
%Test if the maximum and minimum vector has the relative distance they
%should have:
if abs(length(minimum)-length(maximum)) > 1
    datamessage = [' See ERROR below, this is correponding data. The maximum vector was ', num2str(maximum), ' and the minimum vector ', num2str(minimum), '.'];
    disp(datamessage);
    error('The difference between the minimum and maximum vector is larger than 1, this means that something is wrong in the creation of the minium and maximum vectors');
end

if (isempty(minimum) && isempty(maximum))
    %Do nothing with the coordinates if both minimum and maximum is empty
    minmax_coor = [];
else
    minmax_coor = zeros(2,length(minimum)+length(maximum)+1);
    
    %If only one edge, then this can be checked with once.
    if isleft && isempty(minimum)
        minmax_coor(:,1) = [pgrid(1)-h; maximum];
        minmax_coor(:,2) = [maximum; maximum];
    elseif isleft==0 && isempty(maximum)
        minmax_coor(:,1) = [minimum; pgrid(end)+h];
        minmax_coor(:,2) = [minimum; minimum];
    else %There is elements in both minimum and maximum, therefore the coordinates for the minimum and maximum must be found in another way.
        if isleft %if the memory curve starts from the left
            if length(maximum) > length(minimum) %last point is a maximum -> go down and right. We know that length(minimum) >= 1
                k = 0;
                for j=1:length(maximum)
                    if j==1
                        k=k+1;
                        minmax_coor(:,k) = [pgrid(1)-h;maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                    elseif j==length(maximum)
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j-1);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [maximum(j);maximum(j)];
                    else
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j-1);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                    end
                end
            elseif length(maximum) == length(minimum) %last point is a minimum -> go right and down
                k = 0;
                for j=1:length(maximum)
                    if j==1 && j== length(maximum)
                        k=k+1;
                        minmax_coor(:,k) = [pgrid(1)-h;maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);minimum(j)];
                    elseif j==1
                        k=k+1;
                        minmax_coor(:,k) = [pgrid(1)-h;maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j+1)];
                    elseif j==length(maximum)
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);minimum(j)];
                    else
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j+1)];
                    end
                end
            else
                datamessage = [' See ERROR below, this is correponding data. The maximum vector was ', num2str(maximum), ' and the minimum vector ', num2str(minimum), '.'];
                disp(datamessage);
                error('Minimum is longer than maximum when isleft=1, this must be wrong');
            end
        elseif isleft==0 %if the memory curve starts from the top
            if length(minimum) > length(maximum) %last point is a minimum -> go right and down. We know that length(maximum) >= 1
                k = 0;
                for j=1:length(minimum)
                    if j==1
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);pgrid(end)+h];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                    elseif j==length(minimum)
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j-1)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);minimum(j)];
                    else
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j-1)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                    end
                end
            elseif length(minimum) == length(maximum) %last point is a maxium -> go down and right
                k = 0;
                for j=1:length(minimum)
                    if j==1 && j==length(minimum)
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);pgrid(end)+h];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [maximum(j);maximum(j)];
                    elseif j==1
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);pgrid(end)+h];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j+1);maximum(j)];
                    elseif j==length(minimum)
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [maximum(j);maximum(j)];
                    else
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j);maximum(j)];
                        k=k+1;
                        minmax_coor(:,k) = [minimum(j+1);maximum(j)];
                    end
                end
            else
                datamessage = [' See ERROR below, this is correponding data. The maximum vector was ', num2str(maximum), ' and the minimum vector ', num2str(minimum), '.'];
                disp(datamessage);
                error('Maximum is longer than minimum when isleft=0, something is wrong');
            end
        end
    end
end

min_vector = minimum;
max_vector = maximum;

end

