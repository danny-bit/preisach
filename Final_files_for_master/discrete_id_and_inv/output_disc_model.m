function [ y ] = output_disc_model( mu, t, N, alpha, beta,x,A,d )
%ID_MODEL Summary of this function goes here
%   Detailed explanation goes here
    
Q = (N*(N+1))/2;
h = alpha(2)-alpha(1);

y = zeros(1,length(t));
S = -ones(1,Q);
for i = 1:length(t)
    yi = 0;
        for j = 1:Q
            [R,S(j)] = relay_operator(alpha(j),beta(j),S(j),x(i),h);
            yi = yi + mu(j)*A(j)*R;
        end
    y(i) = yi + d;
end
y = y';

end
