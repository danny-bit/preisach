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
u = simout

w = [];

for k = 1:length(u)
    [tmp,gamma] = preisach_v1(u(k),gamma,mu);
    w(k) = tmp;
end

figure;
subplot(311)
plot(u)
subplot(312)
plot(w)
subplot(313)
plot(u,w)

figure; hold on;
mask = (gamma(:,3)==1);
plot(gamma(mask,2),gamma(mask,1),'rx')

mask = (gamma(:,3)==-1);
plot(gamma(mask,2),gamma(mask,1),'bo')