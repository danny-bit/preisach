N = 50;
u_delta = 10/N;

gamma = zeros(N,3);

count = 1;
for alpha_k = 1:N
    for beta_k = 1:alpha_k
        count = count+1;
        gamma(count,:) = [u_delta*alpha_k, u_delta*beta_k, 0];
    end
end

figure;
plot(gamma(:,2),gamma(:,1),'x')
xlabel('beta')
ylabel('alpha')

mu = ones(length(gamma),1);

u = 0:0.1:10;
u = [u, 10:-0.1:3];
u = [u, 3:0.1:7];
u = [u, 7:-0.1:4];
u = [u, 4:0.1:6];
%u = [u, 6:-0.1:0];


w = [];

for k = 1:length(u)
    [tmp,gamma] = preisach_v1(u(k),gamma,mu);
    w(k) = tmp;
end

figure;
subplot(211)
plot(u)
subplot(212)
plot(u,w)

figure; hold on;
mask = (gamma_hat==1);
plot(gamma(mask,2),gamma(mask,1),'rx')

mask = (gamma_hat==-1);
plot(gamma(mask,2),gamma(mask,1),'bo')
%%


% [1] MAYERGOYZ,  Isaak.  Mathematical  models  of  hysterisis  and  their  applications.  Elsevier,  2003,  ISBN  0-1--480873-5
% [2] Everet, A General approach to hysteresis. Trans. Faraday Soc. 48(8),749(1952)


% TBD: discretisation of the preisach plane
% e.g. regular grid / irregular grid
% By  partitioning  the  Preisach  planeS,  illustrated  in  Equation  2.13,  into  subregions,  asshown in Figure  2.16,  the  Preisach plane  will  be  discretized.   
% Within each sub-region,  therelays are assumed to switch simultaneously depending on the applied inputu(·),  and theweighting valuesμα,βare the same within that regio

% TBD: implementation 
% - direct / memory curve / interpolation
% - numerical integration of distributions