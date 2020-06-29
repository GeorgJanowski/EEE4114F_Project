% Compares the convergence of the LMS algorithm using inintialise and
% uninitailised weights.


clear;

%% Soundfile names
sf1 = ["sf1_cln.wav", "sf1_fi1.wav", "sf1_fi2.wav", "sf1_fi3.wav", "sf1_fi4.wav"];
sm1 = ["sm1_cln.wav", "sm1_fi1.wav", "sm1_fi2.wav", "sm1_fi3.wav", "sm1_fi4.wav"];

% read in soundfiles
[sf1_cln,r] = audioread("../soundfiles/" + sf1(1));
sf1_fi1 = audioread("../soundfiles/" + sf1(2));
sf1_fi2 = audioread("../soundfiles/" + sf1(3));
sf1_fi3 = audioread("../soundfiles/" + sf1(4));
sf1_fi4 = audioread("../soundfiles/" + sf1(5));
sf1_fi4 = sf1_fi4(1:41677);

%% Channel and noise level
h = [0.9 0.3 0.5 -0.1]; % Channel
% h = [1,1,1,1,1,1,1]; % Channel
SNRr = 65;              % Noise Level

%% Input/Output data
d = sf1_cln;            % Signal befor passing through channel
out = sf1_fi2;            % Signal after passing through channel
x = awgn(out,45);
% x = awgn(x, SNRr);      % Noisy Signal after channel

%% Zero Forcing Equalizer
% estimate channel impulse response
data = iddata(x, d);

sys = impulseest(data);

% extract impulse response
[num,den] = tfdata(sys,'v');

% do zfe manually
x_zfe = filter(den,num,x);

data_i = iddata(d,x);
sys_i = impulseest(data_i);

% extract impulse response
[num_i,den_i] = tfdata(sys_i,'v');

x_zfe_i = filter(num_i,den_i,x);

%% LMS parameters
epoch = 50;        % Number of epochs (training repetation)
eta = 0.1;         % Learning rate / step size
order=70;           % Order of the equalizer

U = zeros(1,order); % Input frame
W = zeros(1,order); % Initial Weigths

% W_0 = mmse_lms(d,x,zeros(1,order));
% W_1 = mmse_lms(d,x,num_i);

%% Algorithm
for k = 1 : epoch
    for n = 1 : length(d)
        U(1,2:end) = U(1,1:end-1);  % Sliding window
        U(1,1) = x(n);              % Present Input
     
        y = (W)*U';             % Calculating output of LMS
        e = d(n) - y;           % Instantaneous error 
        W = W +  eta * e * U ;  % Weight update rule of LMS
        J1(k,n) = e * e';        % Instantaneous square error
    end
end

U = zeros(1,order); % Input frame
W = num_i; % Initial Weigths

for k = 1 : epoch
    for n = 1 : length(d)
        U(1,2:end) = U(1,1:end-1);  % Sliding window
        U(1,1) = x(n);              % Present Input
        
        y = (W)*U';             % Calculating output of LMS
        e = d(n) - y;           % Instantaneous error 
        W = W +  eta * e * U ;  % Weight update rule of LMS
        J2(k,n) = e * e';        % Instantaneous square error
        
    end
end
%%
x = awgn(out,55);

data_i = iddata(d,x);
sys_i = impulseest(data_i);

% extract impulse response
[num_i,den_i] = tfdata(sys_i,'v');

for k = 1 : epoch
    for n = 1 : length(d)
        U(1,2:end) = U(1,1:end-1);  % Sliding window
        U(1,1) = x(n);              % Present Input
     
        y = (W)*U';             % Calculating output of LMS
        e = d(n) - y;           % Instantaneous error 
        W = W +  eta * e * U ;  % Weight update rule of LMS
        J3(k,n) = e * e';        % Instantaneous square error
    end
end

U = zeros(1,order); % Input frame
W = num_i; % Initial Weigths

for k = 1 : epoch
    for n = 1 : length(d)
        U(1,2:end) = U(1,1:end-1);  % Sliding window
        U(1,1) = x(n);              % Present Input
        
        y = (W)*U';             % Calculating output of LMS
        e = d(n) - y;           % Instantaneous error 
        W = W +  eta * e * U ;  % Weight update rule of LMS
        J4(k,n) = e * e';        % Instantaneous square error
        
    end
end
%%
x = awgn(out,65);

data_i = iddata(d,x);
tic
sys_i = impulseest(data_i);
toc
% extract impulse response
[num_i,den_i] = tfdata(sys_i,'v');
tic
for k = 1 : epoch
    for n = 1 : length(d)
        U(1,2:end) = U(1,1:end-1);  % Sliding window
        U(1,1) = x(n);              % Present Input
     
        y = (W)*U';             % Calculating output of LMS
        e = d(n) - y;           % Instantaneous error 
        W = W +  eta * e * U ;  % Weight update rule of LMS
        J5(k,n) = e * e';        % Instantaneous square error
    end
end
toc
U = zeros(1,order); % Input frame
W = num_i; % Initial Weigths

for k = 1 : epoch
    for n = 1 : length(d)
        U(1,2:end) = U(1,1:end-1);  % Sliding window
        U(1,1) = x(n);              % Present Input
        
        y = (W)*U';             % Calculating output of LMS
        e = d(n) - y;           % Instantaneous error 
        W = W +  eta * e * U ;  % Weight update rule of LMS
        J6(k,n) = e * e';        % Instantaneous square error
        
    end
end

%% Filtering channel output with inverse filter
% x_mmse_0 = filter(W_0,1,x);

% x_mmse_1 = filter(W_1,1,x);

% mse(d,x)
% mse(d,x_zfe)
% mse(d,x_zfe_i)
% mse(d,x_mmse_0)
% mse(d,x_mmse_1)

%% Calculation of performance parameters
MJ1 = mean(J1,2);     % Mean square error
MJ2 = mean(J2,2);     % Mean square error
MJ3 = mean(J3,2);     % Mean square error
MJ4 = mean(J4,2);     % Mean square error
MJ5 = mean(J5,2);     % Mean square error
MJ6 = mean(J6,2);     % Mean square error

%% Plots
fsize=12;
lw=2;
figure() % MSE
plot(10*log10(MJ1),'-*','Color',[0 0 1],'linewidth',lw)
hold on
plot(10*log10(MJ2),'->','Color',[0 0 1],'linewidth',lw)
plot(10*log10(MJ3),'-*','Color',[0 0.7 0],'linewidth',lw)
plot(10*log10(MJ4),'->','Color',[0 0.7 0],'linewidth',lw)
plot(10*log10(MJ5),'-*','Color',[1 0 0],'linewidth',lw)
plot(10*log10(MJ6),'->','Color',[1 0 0],'linewidth',lw)
hold off
grid on
xlabel('Number of iterations');
ylabel('MSE (dB)');
title('Cost function (fi2)','FontSize',fsize);
legend('Unitialised Weights (-10 dB)', 'Initialised Weights (-10 dB)','Unitialised Weights (0 dB)', 'Initialised Weights (0 dB)','Unitialised Weights (10 dB)', 'Initialised Weights (10 dB)');
