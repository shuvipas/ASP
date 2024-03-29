function [rxbits,filterOut, halfBetta] = RX1(config,ChannelOutVec)
% Receives a transmitted signal through a channel and decodes the transmitted bits using a matched filter.
% Asumming sinc pulses with sinchronization and modulation.
% Parameters:
% config: Given configuration struct.
% ChannelOutVec: Vector of the signal received through the channel.
% rxbits: Vector of the decoded bits.

ChannelOutVec = ChannelOutVec(:)';
halfBetta = 0;

if(config.pulsetype)
    txpulse = config.tpulsesinc;
else 
    txpulse = config.tpulserect;
end

if(config.mod)
    n = (1:length(ChannelOutVec));
    modulation = cos((2*pi*config.Fc*n)/(config.Fs));
    ChannelOutVec = ChannelOutVec.*modulation;
    ChannelOutVec = conv(ChannelOutVec,config.RxLPFpulse);
end

if(config.synch)
    matchedfiltcoeffs = config.synchsymbol(end:-1:1);
    filtout = filter(matchedfiltcoeffs,1,ChannelOutVec(1:4*config.Fs));
    [MaxVal,IndexSynch] = max(abs(filtout));
    if(config.mod)
        
        halfBetta = MaxVal/sum(config.synchsymbol.^2)*sign(filtout(IndexSynch));
        ChannelOutVec = ChannelOutVec/halfBetta;
    end
end

matchedfiltcoeffs = txpulse(end:-1:1);
filterOut = filter(matchedfiltcoeffs,1,ChannelOutVec);

sampleSpace = config.Fs/config.B;
sampleVec = zeros(1,config.K);


if(config.synch)
    startPoint = IndexSynch + 1;
else
    startPoint = config.Fs + length(txpulse);
end


for i=1:config.K
    sampleVec(i) = filterOut(startPoint + (i-1)*sampleSpace);
end

BPSK = sign(sampleVec);
rxbits = (1-BPSK)./2;

end
