function [ChannelInVec] = TX1(config,infobits)
% This function takes in configuration parameters and binary information bits to be transmitted
% and generates a modulated signal that is passed through the channel.
% Asumming sinc pulses with sinchronization and modulation.
% Parameters:
% config: Given configuration struct.
% infobits: a vector of binary information bits to be transmitted.
% ChannelInVec: a vector representing the transmitted signal before passing through the channel.
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
