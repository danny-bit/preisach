function [ v,u_prev ] = invert_presiach_cont( desired_output,pgrid,isleft, A, mu, d,d_scaling)
%INVERT_PRESIACH_CONT Continuous inverse based on a desired output Closest
%match algorithm

%REMARK:
%This inversion seems to work well for a desired output which corresponds
%to a input value inside the input range, but gives error when the desired
%output exceeds this level. If time, this should be fixed in order to have
%more robust code. However, the inversion works splendidly if the
%corresponding input is in the range.

h = (pgrid(2)-pgrid(1))/2;
N = length(pgrid);
Q = (N*(N+1))/2;

global x x_prev first_3 OnOff_vector_prev OnOff_matrix_prev minimum maximum prev_desired

if isempty(first_3)
    x = 0;
    x_prev = NaN;
    first_3 = 1;
    OnOff_vector_prev = zeros(1,Q);
    OnOff_matrix_prev = zeros(N,N);
    minimum = [];
    maximum = [];
    prev_desired = -100;
    
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
    
    if d_scaling <= 0 || d_scaling >=1
        error('d_scaling should be larger than zero and less than 1');
    end
end

diff = x - x_prev;
[minmax_coor, isleft, minimum, maximum] = get_minmax_vector(x,x_prev,pgrid,h,isleft, minimum, maximum);
v_k = minmax_coor(1,end);
[u_prev, OnOff_vector_prev, OnOff_matrix_prev] = calc_preisach_output_cont(minmax_coor, minimum, maximum, isleft, pgrid, A, mu, d, OnOff_vector_prev, OnOff_matrix_prev);
num_of_iter = 0;

if (desired_output == prev_desired) %if the same as in the previous case, then use the previous input.
    v = x;
else
    iteration_cond = 1;
    while iteration_cond
        % %Changes in the iterations, but must be set equal to the current state at
        % %the start:
        OnOff_vector_iteration = OnOff_vector_prev;
        OnOff_matrix_iteration = OnOff_matrix_prev;

        coordinates = find_coor_vector(minmax_coor,pgrid);
        if desired_output > u_prev
            if (pgrid((coordinates(1,end))) + h) ~= v_k
                d1_k = (pgrid((coordinates(1,end))) + h) - v_k;
            else
                d1_k = (pgrid((coordinates(1,end))+1) + h) - v_k;
            end
            if length(minmax_coor(2,:)) < 3
                d2_k = pgrid(end) + h - v_k;
            else
                d2_k = minmax_coor(2,end-2) - v_k;
            end

            d_iter = d_scaling*min([d1_k,d2_k]);
            isleft_iteration = isleft;
            minimum_iteration = minimum;
            maximum_iteration = maximum;
            [minmax_coor_iteration, isleft_iteration, minimum_iteration, maximum_iteration] = get_minmax_vector(x + d_iter,x,pgrid,h,isleft_iteration, minimum_iteration, maximum_iteration);
            u_iteration = calc_preisach_output_cont(minmax_coor_iteration, minimum_iteration, maximum_iteration, isleft_iteration, pgrid, A, mu, d, OnOff_vector_iteration, OnOff_matrix_iteration);

                Output_diff = u_iteration - u_prev;
            if (Output_diff == 0)

                warning('Output_diff is zero in invert_preisach_cont. This is probable due to zero elements on the triangle cells in the mu vector. Use a identified model which dont have zero elements on the diagonal');
                Output_diff = 1e-10;
            end
            a1_k = 1;
            run_again = 1;
            while run_again
                a2_k = Output_diff/d_iter^2 - a1_k/d_iter;

                if a2_k >= 0
                    run_again = 0;
                else
                    a1_k = a1_k/2;
                end
            end
            Desired_diff = desired_output - u_prev;

            d0_k = (-a1_k + sqrt(a1_k^2 - 4*a2_k*(-Desired_diff)))/(2*a2_k);
            if d0_k < 0
                error('d0_k is less than zero for u_des > u_prev');
            end

            d_k = min([d0_k,d1_k,d2_k]);
            v_k = v_k + d_k;

        elseif desired_output < u_prev
            if v_k ~= pgrid((coordinates(2,end))) - h
                d1_k = v_k - (pgrid((coordinates(2,end))) - h);
            else
                d1_k = v_k - (pgrid((coordinates(2,end)-1)) - h);
            end
            if length(minmax_coor(2,:)) < 3
                d2_k = v_k - (pgrid(1) - h);
            else
                d2_k = v_k - minmax_coor(1,end-2);
            end

            d_iter = d_scaling*min([d1_k,d2_k]);
            isleft_iteration = isleft;
            minimum_iteration = minimum;
            maximum_iteration = maximum;
            [minmax_coor_iteration, isleft_iteration, minimum_iteration, maximum_iteration] = get_minmax_vector(x - d_iter,x,pgrid,h,isleft_iteration, minimum_iteration, maximum_iteration);
            u_iteration = calc_preisach_output_cont(minmax_coor_iteration, minimum_iteration, maximum_iteration, isleft_iteration, pgrid, A, mu, d, OnOff_vector_iteration, OnOff_matrix_iteration);

            Output_diff = u_iteration - u_prev;
            if Output_diff == 0
                warning('Output_diff is zero in invert_preisach_cont. This is probable due to zero elements on the triangle cells in the mu vector. Use a identified model which dont have zero elements on the diagonal');
                Output_diff = -1e-10;
            end
            a1_k = -1;
            run_again = 1;
            while run_again
                a2_k = Output_diff/d_iter^2 - a1_k/d_iter;
                if a2_k <= 0
                    run_again = 0;
                else
                    a1_k = a1_k/2;
                end
            end
            Desired_diff = desired_output - u_prev;
            a1_k = -1*a1_k;
            a2_k = -1*a2_k;
            Desired_diff = -1*Desired_diff;
            d0_k = (-a1_k + sqrt(a1_k^2 - 4*a2_k*(-Desired_diff)))/(2*a2_k);
            if d0_k < 0
                error('d0_k is less than zero for u_des > u_prev');
            end
            d_k = min([d0_k,d1_k,d2_k]);
            v_k = v_k - d_k;
        end
        x_prev = x;
        [minmax_coor, isleft, minimum, maximum] = get_minmax_vector(v_k,x_prev,pgrid,h,isleft, minimum, maximum);
        [u_prev, OnOff_vector_prev, OnOff_matrix_prev] = calc_preisach_output_cont(minmax_coor, minimum, maximum, isleft, pgrid, A, mu, d, OnOff_vector_prev, OnOff_matrix_prev);
        x = v_k;
        if d_k == d0_k || num_of_iter >100
            iteration_cond = 0;
        elseif num_of_iter > 100
            iteration_cond = 0;
            warning('Iteration count reached 100 and inversion algorithm exits, the output might not be optimal');
        else
            num_of_iter = num_of_iter +1;
        end
    end
    v = v_k;
end
prev_desired = desired_output;
end