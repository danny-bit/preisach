function [ mu, y, AMP,pgrid,alpha,beta,A,RA,h,N,S,par ] = preisach_id( t, x, Y, N )
%PREISACH_ID Summary of this function goes here
%   Detailed explanation goes here
    
    Q = (N*(N+1))/2;
    
    %AMP = 1.04*max(abs(x));
    AMP = 89;
    RANGE = AMP; %Range for the preisach density function
    
    h = RANGE/(N/2); %Size on each 
    pgrid = -RANGE+h/2:h:RANGE-h/2;
    lgrid = -RANGE:h:RANGE;

    k = 0;
    alpha = zeros(1,Q);
    beta = zeros(1,Q);
    A = zeros(1,Q);
    for i = 1:N
        for j = i:N
            k = k+1;
            alpha(k) = pgrid(j);
            beta(k) = pgrid(i);
            A(k) = h^2;
        end
        if i >= 2
            r = factorial(i)/(factorial(2)*factorial(i-2));
        else
            r = 0;
        end 
        kh = round(N*(i-1) - r + i);
        A(kh) = h^2/2;
    end

    switch 2
    case 1
        figure(3);clf(3);
        plot(beta,alpha,'r.');
        for i = 1:Q
            ox = -0.2;
            oy = 0.2;
            text(beta(i)+ox,alpha(i)+oy,num2str(i)); %Writes out the number i to the plot at coordinate
%             ox = 0.2;
%             oy = -0.03;
            %text(beta(i)+ox,alpha(i)+oy,num2str(A(i)));
        end
        axis([-RANGE RANGE -RANGE RANGE]);
        hold on;
        plot([-RANGE RANGE],[-RANGE,RANGE],'k');%Plot the x values (first vector) against y values (second vector)
        for i = 1:N
            plot([-RANGE lgrid(i)], [lgrid(i) lgrid(i)],'k'); %plot horisontical lines
            plot([lgrid(i) lgrid(i)], [lgrid(i) RANGE],'k'); %plot vertical lines
        end
        xlabel('\beta');
        ylabel('\alpha');
        hold off
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);

    case 2
        FIT_ON = 1;
        if FIT_ON
            S = -ones(1,Q);
            %initialize the memory curve with the first input
            for k = 1:Q
                [R,S(k)] = relay_operator(alpha(k),beta(k),S(k),x(1),h);
            end
            RA = zeros(length(t),Q);
            for i = 1:length(t)
                for j = 1:Q
                    [R,S(j)] = relay_operator(alpha(j),beta(j),S(j),x(i),h);
                    RA(i,j) = A(j)*R;
                end
            end
            %mu = RA\Y;
            abc = optimoptions('lsqnonlin','MaxFunEvals',20);
            par = 0;
            par = lsqnonlin('preisach_id_func_constant_bias_discrete',par,-Inf,Inf,abc,Y,t,RA);
            
            [mu,RESNORM,RESIDUAL,EXITFLAG] = lsqnonneg(RA,Y-par);
        end

        y = zeros(1,length(t));
        S = -ones(1,Q);
        %initialize the memory curve with the first input
        for k = 1:Q
            [R,S(k)] = relay_operator(alpha(k),beta(k),S(k),x(1),h);
        end
        for i = 1:length(t)
            yi = 0;
            for j = 1:Q
                [R,S(j)] = relay_operator(alpha(j),beta(j),S(j),x(i),h);
                yi = yi + mu(j)*A(j)*R;
            end
            y(i) = yi + par;
        end
        y = y';
    end
end

