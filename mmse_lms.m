% Finds impulse response mmse equalizer using LMS algorithm
function W = mmse_lms(d,x,W)
% d - input signal to channel
% x - output from channel
% W - impulse response initial weights

epoch = 50;
eta = 0.1;
U = zeros(1,length(W)); % Input frame
% W = zeros(1,order); % Initial Weigths

for k = 1 : epoch
    for n = 1 : length(d)
        U(1,2:end) = U(1,1:end-1);  % Sliding window
        U(1,1) = x(n);              % Present Input
     
        y = (W)*U';             % Calculating output of LMS
        e = d(n) - y;           % Instantaneous error 
        W = W +  eta * e * U ;  % Weight update rule of LMS
    end
end

end