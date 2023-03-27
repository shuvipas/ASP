function [ChannelInVec] = TX(config,infobits)
% This function takes in configuration parameters and binary information bits to be transmitted
% and generates a modulated signal that is passed through the channel.

% Parameters:
% config: Given configuration struct.
% infobits: a vector of binary information bits to be transmitted.
% ChannelInVec: a vector representing the transmitted signal before passing through the channel.


infobits = infobits(:)';
BPSKbits = 1-2*infobits; 
pulseTrain = upsample(BPSKbits, config.Ts);

txpulse = config.tpulsesinc;

ChannelInVec = conv(txpulse, pulseTrain);

n = (1:length(ChannelInVec));
modulation = cos((2*pi*config.Fc*n)/(config.Fs));
ChannelInVec = ChannelInVec.*modulation;

ChannelInVec = [zeros(1, config.Fs) ChannelInVec zeros(1, 4*config.Fs)];

end
