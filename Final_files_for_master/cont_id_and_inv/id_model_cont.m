function [ y ] = id_model_cont( mu, t, N, alpha, beta,x,A,d,RA )
%ID_MODEL Summary of this function goes here
%   Detailed explanation goes here

pgrid = alpha(1:N);
RA = cont_preisach(x,t,pgrid,N,A);

y = zeros(1,length(t));
for i = 1:length(t)
    y(i) = RA(i,:)*mu + d;
end
y = y';

end
