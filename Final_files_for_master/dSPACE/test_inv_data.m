clear
close all;
Ts = 1e-5;
Fs = 1/Ts;

load invert_data_rising_sine_20hz_15_cont;
u = u';
% u_rem = u;
% u_pp1 = splinefit(t,u,100,4);
% u = ppval(u_pp1,t)';
% 
% figure(1);clf(1);
% plot(t,u,t,u_rem);
% 
% figure(4);clf(4);
% plot(u_rem,u);
% 
% figure(5);clf(5);
% plot(u_rem-u);
%
% u = [u(1:5030);u(1:5030);u(1:5030);u(1:5030);u(1:5030);u];

u_ones = ones(10000,1)*u(5);
u = [u_ones;u];
t = 0:Ts:t(end)+0.1;%+Ts*5*length(u(10001:15030));

u(10001:10004) = u(10000);
%u = smooth(u);

%u_test = smooth(u,0.1);
% for i =3:length(u)-2
%     u(i) = 0.1*u(i-2)+0.2*u(i-1)+0.4*u(i)+0.2*u(i+1)+0.1*u(i+2);
% end

%Fs = 1/Ts;

%FREQ = 15;

%t = 0:Ts:100/FREQ-Ts;
%t = 0:Ts:0.08-Ts;
% y = 90*sin(2*pi*500*t);
%y = 90*sin(2*pi*25*t);

% figure(1)
% plot(t,y)
% 
% NW = round(length(y)/10);
% %win = gausswin(NW);
% %win = hann(NW);
% %win = bartlett(NW);
% %win = hamming(NW);
% %win = rectwin(NW);
% 
% figure(2)
% pwelch(y,[],[],[],Fs,'onesided');
% 
simin.time = [];
simin.signals.values = u;
simin.signals.dimensions = 1;

% figure(1);clf(1);
% plot(u_test);

figure(2);clf(2);
plot(t,u);
hold on;

L = length(u);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(u,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(3);clf(3);
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
axis([0 1000 0 100]);
grid on;
