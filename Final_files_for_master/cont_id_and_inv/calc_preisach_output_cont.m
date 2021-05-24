function [ y, OnOff_vector, OnOff_matrix ] = calc_preisach_output_cont( minmax_vector, minimum, maximum, isleft, pgrid, A, mu, d, OnOff_vector, OnOff_matrix)
%CALC_PREISACH_OUTPUT_CONT Summary of this function goes here
%   Detailed explanation goes here

[OnOff_vector, OnOff_matrix] = get_OnOff_vector(minmax_vector,minimum, maximum, isleft, pgrid, OnOff_vector, OnOff_matrix);
OnOff_vector = OnOff_vector.*A;

y = OnOff_vector*mu + d;


end

