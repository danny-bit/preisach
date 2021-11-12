function test_preisach_simple_callback (u,ax,ax2)

persistent gamma

N = 50;
u_delta = 10/N;

if (isempty(gamma))
    gamma = zeros(N,3);

    count = 1;
    for alpha_k = 1:N
        for beta_k = 1:alpha_k
            count = count+1;
            gamma(count,:) = [u_delta*alpha_k, u_delta*beta_k, 0];
        end
    end
end

mu = ones(length(gamma),1);

[y, gamma] = preisach_simple(u,gamma,mu);

cla(ax);
hold(ax,'on');
mask = (gamma(:,3)==1);
plot(ax, gamma(mask,2),gamma(mask,1),'rx')

mask = (gamma(:,3)==-1);
plot(ax, gamma(mask,2),gamma(mask,1),'bo')

hold(ax2,'on');
plot(u,y,'b x')

grid(ax,'on')
grid(ax2,'on')
ylim(ax2,'auto')
xlim(ax2,'auto')    