function [ inv_input,y_model_out ] = invert_preisach_disc(desired_output,pgrid,isleft, A, mu, d)
%Calculates the inverted signal based on a reference signal.


h = (pgrid(2)-pgrid(1));
N = length(pgrid);
Q = (N*(N+1))/2;

global u_glob u_prev_glob first_5 OnOff_vector_prev OnOff_matrix_prev minimum maximum prev_desired

if isempty(first_5)
    first_5 = 1;
    
    u_glob = pgrid(1);
    u_prev_glob = NaN;
    OnOff_vector_prev = -1*ones(1,Q);
    OnOff_matrix_prev = zeros(N,N);
    minimum = [];
    maximum = [];
    prev_desired = -100;
    
    %check if the identified weighs are valis are valid:
    distribution = zeros(N,N);
    k = 0;
    for i = N:-1:1
        for j = i:-1:1
            k = k+1;
            distribution(i,j)= mu(k);
        end
    end
    check_var = 0;
    for i = 1:N
        if (distribution(i,i) == 0)
            check_var = 1;
        end
    end
    if check_var == 1
        warning('The distribution of the identified mu contains zero diagonal elements. This will result in a bad inverse input! you SHOULD use a better model for inverting a signal. This model is NOT good enough.');
    end
end

[minmax_coor, isleft, minimum, maximum] = get_minmax_vector(u_glob,u_prev_glob,pgrid,h,isleft, minimum, maximum);
u = minmax_coor(1,end);
[y, OnOff_vector_prev, OnOff_matrix_prev] = calc_preisach_output_cont(minmax_coor, minimum, maximum, isleft, pgrid, A, mu, d, OnOff_vector_prev, OnOff_matrix_prev);

while 1 %NOT an infinite loop, when the closest match is found, it returns out of this function.
    if (y == desired_output)
        inv_input = u;
        y_model_out = y;
        return;
    elseif (y < desired_output)
        
        lower = 1;
        while(lower)
            if u >= pgrid(end)+h/2
                inv_input = pgrid(end)+h/2;
                y_model_out = y;
                return;
            else
                u_past = u;
                u = u + h;
                minimum_past = minimum;
                maximum_past = maximum;
                [minmax_coor, isleft, minimum, maximum] = get_minmax_vector(u,u_past,pgrid,h,isleft,minimum,maximum);
                y_past = y;
                [y, OnOff_vector_prev, OnOff_matrix_prev] = calc_preisach_output_cont(minmax_coor, minimum, maximum, isleft, pgrid, A, mu, d, OnOff_vector_prev, OnOff_matrix_prev);
                if (y == desired_output)
                    inv_input = u;
                    y_model_out = y;
                    u_glob = u;
                    u_prev_glob = u_past;
                    return;
                elseif (y < desired_output)
                    %run the while loop once again
                    u_glob = u;
                    u_prev_glob = u_past;
                else
                    lower = 0;
                end
            end
        end
        y_diff = abs(y-desired_output);
        y_past_diff = abs(y_past-desired_output);
        if( y_diff < y_past_diff)
            u_glob = u;
            u_prev_glob = u_past;
        else
            inv_input = u_past;
            y_model_out = y_past;
            %u_glob and u_prev_glob is the same as before.
            minimum = minimum_past;
            maximum = maximum_past;
            return;
        end
    elseif (y > desired_output);
        higher = 1;
        while(higher)
            if u <= pgrid(1)-h/2;
                inv_input = pgrid(end)-h/2;
                y_model_out = y;
                return;
            else
                u_past = u;
                u = u-h;
                minimum_past = minimum;
                maximum_past = maximum;
                [minmax_coor, isleft, minimum, maximum] = get_minmax_vector(u,u_past,pgrid,h,isleft,minimum,maximum);
                y_past = y;
                [y, OnOff_vector_prev, OnOff_matrix_prev] = calc_preisach_output_cont(minmax_coor, minimum, maximum, isleft, pgrid, A, mu, d, OnOff_vector_prev, OnOff_matrix_prev);
                if (y==desired_output)
                    inv_input = u;
                    y_model_out = y;
                    u_glob = u;
                    u_prev_glob = u_past;
                    return;
                elseif (y > desired_output)
                    u_glob = u;
                    u_prev_glob = u_past;
                    %run the while loop once more
                else
                    higher = 0;
                end
            end
        end
        
        y_diff = abs(y-desired_output);
        y_past_diff = abs(y_past-desired_output);
        if( y_diff < y_past_diff)
            u_glob = u;
            u_prev_glob = u_past;
        else
            inv_input = u_past;
            y_model_out = y_past;
            minimum = minimum_past;
            maximum = maximum_past;
            return;
        end
    end
end
end