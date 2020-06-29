% Compare different equalisers across range of noise levels

% Soundfile names
sf1 = ["sf1_cln.wav", "sf1_fi1.wav", "sf1_fi2.wav", "sf1_fi3.wav", "sf1_fi4.wav"];
sm1 = ["sm1_cln.wav", "sm1_fi1.wav", "sm1_fi2.wav", "sm1_fi3.wav", "sm1_fi4.wav"];

% read in soundfiles
[sf1_cln,r] = audioread("../soundfiles/" + sf1(1));
sf1_fi1 = audioread("../soundfiles/" + sf1(2));
sf1_fi2 = audioread("../soundfiles/" + sf1(3));

x = sf1_cln;
y = sf1_fi1;

% add noise
% sig_power = bandpower(y);
% sig_power_dB = 10*log(sig_power);


SNR = 50;
step = 5;

for i = 1:1
    %% Add noise
    SNRi = SNR + i * step
    y_n0 = awgn(y,SNRi);
    
    %% ZFE
    data = iddata(y_n0, x);
    sys = impulseest(data);
    [num,den] = tfdata(sys,'v');
    y_zfe = filter(den,num,y_n0);

    %% MMSE
    % get estimate with lms algorithm
    W = mmse_lms(x,y_n0,zeros(1,order));
    y_mmse = filter(W,1,y_n0);

    %% MSE
    mse_zfe = mse(x,y_zfe)
    mse_mmse = mse(x,y_mmse)

end

%% MMSE_CN
% channel_est = f_est;
% noise_est = 0;
% fi1_est_mmse_cn = mmse_cn(channel_est,noise_est);
% y_mmse_cn = filter(1,fi1_est_mmse_cn,y_n0);

%% LMMSE
% f_est_transpose = f_est';
% [y_lmmse,f_lmmse] = LMMSE(f_est,y_n0,1,length(y_n0));




%% Plots

% figure();
% bode(f_lmmse);
% 
% figure();
% bode(tf(1,f_est));
% 
% figure();
% subplot(4,1,1);
% plot(x);
% subplot(4,1,2);
% plot(y_zfe);
% subplot(4,1,3);
% plot(y_mmse_lms);
% subplot(4,1,4);
% plot(y_lmmse);


