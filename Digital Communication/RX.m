function [rxbits] = RX(config,ChannelOutVec)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

ChannelOutVec = ChannelOutVec(:)';

txpulse = config.tpulsesinc;

n = (1:length(ChannelOutVec));
modulation = cos((2*pi*config.Fc*n)/(config.Fs));
ChannelOutVec = ChannelOutVec.*modulation;
ChannelOutVec = conv(ChannelOutVec,config.RxLPFpulse);


matchedfiltcoeffs = config.synchsymbol(end:-1:1);
filtout = filter(matchedfiltcoeffs,1,ChannelOutVec(1:4*config.Fs));
[MaxVal,IndexSynch] = max(abs(filtout));
    
halfBetta = MaxVal/sum(config.synchsymbol.^2)*sign(filtout(IndexSynch));
ChannelOutVec = ChannelOutVec/halfBetta;
   

matchedfiltcoeffs = txpulse(end:-1:1);
filterOut = filter(matchedfiltcoeffs,1,ChannelOutVec);

sampleSpace = config.Fs/config.B;
sampleVec = zeros(1,config.K);


startPoint = IndexSynch + 1;

for i=1:config.K
    sampleVec(i) = filterOut(startPoint + (i-1)*sampleSpace);
end

BPSK = sign(sampleVec);
rxbits = (1-BPSK)./2;

end
