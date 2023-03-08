function [ChannelInVec] = TX(config,infobits)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
BPSKbits = 1-2*infobits; %making bernuli vector
pulseTrain = upsample(BPSKbits, config.Ts);%making the pulse train

if(config.pulsetype)
    txpulse = config.tpulsesinc;

else 
     txpulse = config.tpulserect;
end

ChannelInVec = conv(txpulse, pulseTrain);
ChannelInVec = [zeros(1, config.Fs) ChannelInVec zeros(1, 4*config.Fs)];

end