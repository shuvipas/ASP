function [ChannelInVec] = TX(config,infobits)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
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
