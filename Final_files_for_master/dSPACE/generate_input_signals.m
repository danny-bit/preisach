%close all;
clear all;

Ts = 1e-5;
Fs = 1/Ts;

FREQ = 20;
NumOfCycles = 100;

input_signal = 7; %1 for small sine amp, 2 for large sine amp, 3 for PE input, 4 for PRBN signal, 5 for double PE

switch input_signal
    case 1
        t = 0:Ts:NumOfCycles/FREQ-Ts;
        y = 10*sin(2*pi*FREQ*t);
        
    case 2
        
        t = 0:Ts:NumOfCycles/FREQ-Ts;
        y = 90*sin(2*pi*FREQ*t);
        
    case 3
        

        Range = 180; %The input range
        
        NumOfCycles = NumOfCycles+1;
        
        listOfMaximums = linspace(0,Range,NumOfCycles);
        
        t =0:Ts:(NumOfCycles-1)/FREQ-Ts;
        
        y = 0.5+0.5*sawtooth(FREQ*2*pi*t,0.5);
        stair_output = zeros(1,length(t));
        n_cycles = 0;
        length_of_cycle = length(0:Ts:1/FREQ-Ts);
        while (n_cycles < NumOfCycles-1)
            for i=1:length_of_cycle
                stair_output(n_cycles*length_of_cycle+i) = listOfMaximums(n_cycles+2);
            end
            n_cycles = n_cycles+1;
        end
        
        if((NumOfCycles-1)*length_of_cycle < length(t))
            difference = length(t) - (NumOfCycles-1)*length_of_cycle;
            stair_output((NumOfCycles-1)*length_of_cycle:length(t)) = stair_output(end-difference);
        end
        
%         y_zero = linspace(-90,-90,15000);
        y = y.*stair_output-90;
%         y = [y_zero,y];
%         t = 0:Ts:(Ts*length(y)-Ts);
        
        %T = [0 1 2 3 4 5];
        %ytest = [1 1 1 4 4 4];
        
        
        
        %[xx, yy] = stairs(T,ytest);
%         plot(t,y)



    case 4
        
        %Ts = 0.20e-4; % Sampling period

        ul = -1.0; % (-)  Lower amplitude level
        uh = +1.0; % (-)  Upper amplitude level
        n = 5   ; % Order -> length of signal
        fc = 20;  % (Hz) Center frequency (1/2 bandwidth)
        u = generate_prbs_signal(fc,ul,uh,n,Ts);
        t = 0:Ts:(length(u)-1)*Ts;

        u_sync = zeros(size(u)); % Generate syncronization signal
        u_sync(1) = 1;

        U = [u; u_sync];

        AMP = 85.0; % Rescale amplitude (from 1 to AMP)

%         simin.time = [];
%         simin.signals.values = AMP*U';
%         simin.signals.dimensions = size(U,1);

        wc = 2*pi*(10);
        A = [0 1; -wc^2 -sqrt(2)*wc];
        B = [0; wc^2];
        C = [1 0; 0 1];
        D = 0;
        Wlp_ref = ss(A,B,C,D);

        y = lsim(Wlp_ref,AMP*u,t);
        y = y(:,1)';
        y = y(1:72380);
        t = 0:Ts:(length(y)-1)*Ts;
%         figure(1);clf(1);
%         plot(t,y(:,1));
%         
%         figure(2);clf(2);
%         plot(t,u);

    case 5
        
        Range = 180; %The input range
        
        NumOfCycles = NumOfCycles+1;
        
        listOfMaximums = linspace(0,Range,NumOfCycles);
        
        t =0:Ts:(NumOfCycles-1)/FREQ-Ts;
        
        y = 0.5+0.5*sawtooth(FREQ*2*pi*t,0.5);
        stair_output = zeros(1,length(t));
        n_cycles = 0;
        length_of_cycle = length(0:Ts:1/FREQ-Ts);
        while (n_cycles < NumOfCycles-1)
            for i=1:length_of_cycle
                stair_output(n_cycles*length_of_cycle+i) = listOfMaximums(n_cycles+2);
            end
            n_cycles = n_cycles+1;
        end
        
        if((NumOfCycles-1)*length_of_cycle < length(t))
            difference = length(t) - (NumOfCycles-1)*length_of_cycle;
            stair_output((NumOfCycles-1)*length_of_cycle:length(t)) = stair_output(end-difference);
        end
        
        y_1 = y.*stair_output;
        y_2 = linspace(0,180,0.5/(Ts*FREQ));
        y_3 = -1*y.*stair_output+180;
        y_4 = linspace(180,0,0.5/(Ts*FREQ));
        
        y = [y_1 y_2 y_3 y_4];
        y = y-90;
        
%         t = 0:Ts:(Ts*length(y)-Ts);
        
        %[xx, yy] = stairs(T,ytest);
%         plot(t,y)
   

    case 6
        
        t = 0:Ts:NumOfCycles/FREQ-Ts;
        y = zeros(1,length(t))-90;
        
    case 7
        
        t = 0:Ts:NumOfCycles/FREQ-Ts-(1/4)/FREQ;
        gain = linspace(0,90,length(t));
        y = gain.*sin(2*pi*FREQ*t)+gain -90;
        

end



L = length(y);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

figure(2);clf(2);
plot(f,2*abs(Y(1:NFFT/2+1)))
axis([0 500 0 110]);
grid on;
xlabel('Frequency [Hz]');
ylabel('|Y(f)|');

y_zero = linspace(y(1),y(1),15000);
y = [y_zero,y];
t = 0:Ts:(Ts*length(y)-Ts);

Ts = (t(2)-t(1));
Fs = 1/Ts;

figure(1);clf(1);
plot(t,y)
grid on;

simin.time = [];
simin.signals.values = y';
simin.signals.dimensions = 1;
