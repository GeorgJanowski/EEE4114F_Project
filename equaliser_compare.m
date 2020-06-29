% Compare different equalisers in time domain and with MSE.


% Soundfile names
sf1 = ["sf1_cln.wav", "sf1_fi1.wav", "sf1_fi2.wav", "sf1_fi3.wav", "sf1_fi4.wav", "sf1_n1L", "sf1_n1H"];
sm1 = ["sm1_cln.wav", "sm1_fi1.wav", "sm1_fi2.wav", "sm1_fi3.wav", "sm1_fi4.wav"];

% read in soundfiles
[sf1_cln,r] = audioread("../soundfiles/" + sf1(1));
sf1_fi1 = audioread("../soundfiles/" + sf1(2));
sf1_fi2 = audioread("../soundfiles/" + sf1(3));
sf1_n1L = audioread("../soundfiles/" + sf1(3));

% for easy use
x = sf1_cln;
y = sf1_n1L; 
x_train = x(1:r);   % used for training input
y_train = y(1:r); 
x_test = x(r:end);
y_test = y(r:end);

% estimate filter
data = iddata(y_train, x_train);
sys = impulseest(data);

% extract impulse response
[num,den] = tfdata(sys,'v'); % den should be 1

% do zfe manually
o_zfe_man = filter(den,num,y);

% do zfe with function
o_zfe_func = zfe(num,y);

% find mmse analytically
N0 = 1;
f = mmse_cn(num,N0);
[f_num,f_den] = tfdata(f,'v');
o_mmse_cn = filter(f_num,f_den,y);

% find mmse with LMS algorithm
w = mmse_lms(x,y,70);
o_mmse_lms = filter(w,1,y);

% display results
figure();
subplot(4,1,1);
plot(x);
subplot(4,1,2);
plot(y);
subplot(4,1,3);
plot(o_zfe_man);
subplot(4,1,4);
plot(o_zfe_func);

mse(x,y)
mse(x,o_zfe_man)
mse(x,o_zfe_func)
mse(x,o_mmse_cn)
mse(x,o_mmse_lms)

% c = xcorr(sf1_cln,sf1_fi1_zfe);
% length(sf1_cln)
% length(c)
% 
% figure();5
% plot(c);

% figure()
% subplot(2,1,1);plot(num);subplot(2,1,2);plot(out)
% figure();plot(diff);


