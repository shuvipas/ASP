function [ChannelInVec] = TX(config,infobits)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
infobits = infobits(:)';
BPSKbits = 1-2*infobits; %making bernuli vector
pulseTrain = upsample(BPSKbits, config.Ts);%making the pulse train

if(config.pulsetype)
    txpulse = config.tpulsesinc;

else 
     txpulse = config.tpulserect;
end

ChannelInVec = conv(txpulse, pulseTrain);
if(config.mod)
    n = (1:length(ChannelInVec));
    modulation = cos((2*pi*config.Fc*n)/(config.Fs));
    ChannelInVec = ChannelInVec.*modulation;
end
ChannelInVec = [zeros(1, config.Fs) ChannelInVec zeros(1, 4*config.Fs)];

end
