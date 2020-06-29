
clf;

% Soundfile names
sf1 = ["sf1_cln.wav", "sf1_fi1.wav", "sf1_fi2.wav", "sf1_fi3.wav", "sf1_fi4.wav"];
sm1 = ["sm1_cln.wav", "sm1_fi1.wav", "sm1_fi2.wav", "sm1_fi3.wav", "sm1_fi4.wav"];

% read in soundfiles
[sf1_cln,r] = audioread("../soundfiles/" + sf1(1));
sf1_fi1 = audioread("../soundfiles/" + sf1(2));
sf1_fi2 = audioread("../soundfiles/" + sf1(3));

u = sf1_cln;
y = sf1_fi1;

%% zfe
% sf1_fi1
% estimate filter
data = iddata(y, u);
sys = impulseest(data);

% extract impulse response
[num,den] = tfdata(sys,'v');

% do zfe using function
x_func = zfe(num,y);

% do zfe manually
x_man = filter(den,num,y);

%% Comparing time domain signals
figure(1);
subplot(4,1,1);
plot(u(4000:4100));
title('Channel Input');
subplot(4,1,2);
plot(y(4000:4100));
ylabel('Amplitude');
title('Channel Output');
subplot(4,1,3);
plot(x_func(4000:4100));
title('Output Equalised with Inverse Transfer Function');
subplot(4,1,4);
plot(x_man(4000:4100));
xlabel('Samples (n)');
title('Output Equalised with Impulse Response');


%% Comparing power spectal density

% sf1_cln_psd = periodogram(sf1_cln);
% sf1_fi1_psd = periodogram(sf1_fi1);
% sf1_fi1_zfe_psd = periodogram(sf1_fi1_zfe);
% 
% figure();
% subplot(3,1,1);
% plot(sf1_cln_psd);
% subplot(3,1,2);
% plot(sf1_fi1_psd);
% subplot(3,1,3);
% plot(sf1_fi1_zfe_psd);

%% Coherence
% figure(1);
% subplot(4,1,1);
% mscohere(u,u);
% xlabel('');
% ylabel('');
% title('Channel Input');
% subplot(4,1,2);
% mscohere(u,y);
% xlabel('');
% title('Channel Output');
% subplot(4,1,3);
% mscohere(u,x_func);
% xlabel('');
% ylabel('');
% title('Output Equalised with Inverse Transfer Function');
% subplot(4,1,4);
% mscohere(u,x_man);
% ylabel('');
% title('Output Equalised with Impulse Response');

%% MSE
mse(u,y)
mse(u,x_func)
mse(u,x_man)





