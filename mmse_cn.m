% Finds impulse response of mmse equalizer using channel estimate and noise
% estimate.
function f = mmse_cn(c,N0)
% c - channel estimate
% N0 - is nois vairance

%Computing z-transforms of impulse response
cD=filt(c,1); % frequence representation of c[n]
f=1/(cD+N0); %MMSE filter in frequence domain

end