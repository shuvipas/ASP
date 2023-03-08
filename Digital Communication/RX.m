function [rxbits,filterOut ] = RX(config,ChannelOutVec)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
if(config.pulsetype)
    txpulse = config.tpulsesinc;
else 
    txpulse = config.tpulserect;
end
ChannelOutVec = ChannelOutVec(:)';
matchedfiltcoeffs = txpulse(end:-1:1);
filterOut = filter(matchedfiltcoeffs,1,ChannelOutVec);

sampleSpace = config.Fs/config.B;
sampleVec = zeros(1,config.K);

for i=1:config.K
    sampleVec(i) = filterOut(config.Fs + length(txpulse) + (i-1)*sampleSpace);
end

BPSK = sign(sampleVec);
rxbits = (1-BPSK)./2;

end