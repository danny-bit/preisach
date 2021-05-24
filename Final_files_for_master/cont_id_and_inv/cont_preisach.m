function [ area_matrix ] = cont_preisach( x,t,pgrid,N,A )
%CONT_PREISACH Should return a matrix with the areas of all the preisach
%elements
%   Detailed explanation goes here

Q = (N*(N+1))/2;

%PROPOSALS FOR SPEEDING UP THIS FUNCTION:
%- Calculate only A_minus or A_plus, and use this to find the other one.

h = (pgrid(2)-pgrid(1))/2;
%y = zeros(1,length(t));

%assume all relays off at start, therefore the first point is a maximum
maximum = [];
minimum = [];
 %if the memory curve starts from the left or from the top:
if(x(1) > x(2))
    isleft = 0;
    warning('isleft is set to 0 in cont_preisach. If there is large errors between measurement and model, this value might be wrong. Try to change isleft to 1');
else
    isleft = 1;
    warning('isleft is set to 1 in cont_preisach. If there is large errors between measurement and model, this value might be wrong. Try to change isleft to 0');
end
OnOff_matrix = zeros(N,N);
OnOff_vector = zeros(1,Q);
area_matrix = zeros(length(t),Q);
x_prev = NaN;
for i=1:length(t)
    if mod(i,1000) == 0
        disp(num2str(i));
    end
    [minmax_coor, isleft, minimum, maximum] = get_minmax_vector(x(i),x_prev,pgrid,h,isleft, minimum, maximum);
    x_prev = x(i);

    
    [OnOff_vector, OnOff_matrix] = get_OnOff_vector(minmax_coor, minimum, maximum, isleft, pgrid, OnOff_vector, OnOff_matrix);   
    OnOff_vector = OnOff_vector.*A;
    area_matrix(i,:) = OnOff_vector;
    
end


end

