% Filter output (y) of channel (f) with inverse of channel.
function x = zfe(f,y)
% y - signal at the receiver
% f - impulse response of the channel 

% compute inverse of channel
F = tf(f,1);
C = 1/F;
[num,den]=tfdata(C,'v');

% apply equalization filter
x = filter(num,den,y);
end

