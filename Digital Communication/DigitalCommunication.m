clear all
clc
clf
% Q 2

config = load("config.mat").config;
config.pulsetype = 1; % 1 for sinc,  0 for rect
config.K = 1e4;


rectL2norm = sum(config.tpulserect.^2);
plot(config.tpulserect)
str = sprintf("pulse rect, L2 norm = %g", rectL2norm);
title(str)


infobits = rand(1,config.ninfobits)>0.5; %making bernuli vector
BPSKbits = 1-2*infobits; %making bernuli vector
pulseTrain = upsample(BPSKbits, config.Ts);%making the pulse train


figure
subplot(2,1,1)

plot(pulseTrain(1:32*config.Ts))
title("Pulse train of the  first 32 bits")

subplot(2,1,2)
txpulse = config.tpulserect;
TXFiltout = conv(txpulse, pulseTrain);
plot(TXFiltout(1:32*config.Ts))
title("Output of the first 32 bits from the transmission filter")
sgtitle("rect")


figure%}
sincL2norm = sum(config.tpulsesinc.^2);
plot(config.tpulsesinc)
str = sprintf("pulse sinc, L2 norm = %g", sincL2norm);
title(str)

figure

subplot(2,1,1)

plot(pulseTrain(1:32*config.Ts))
title("Pulse train of the  first 32 bits")

subplot(2,1,2)
txpulse = config.tpulsesinc;
TXFiltout = conv(txpulse, pulseTrain);

plot(TXFiltout(1:32*config.Ts))
title("Output of the first 32 bits from the transmission filter")
sgtitle("sER = mean(infobits~=rxbits);inc")

%Q 3
%snr = 100 dB
config.snrdB = 100;
figure
subplot(2,1,1)
ChannelInVec = TX(config,infobits);
plot(ChannelInVec(1:4*config.Fs))
title("First 4 sec of the channel input")

subplot(2,1,2)
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
plot(ChannelOutVec(1:4*config.Fs))
title("First 4 sec of the channel output")

sgtitle("SNR = 100 dB")

%snr = 40 dB
figure
config.snrdB = 40;
subplot(2,1,1)
ChannelInVec = TX(config,infobits);
plot(ChannelInVec(1:4*config.Fs))
title("First 4 sec of the channel input")

subplot(2,1,2)
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
plot(ChannelOutVec(1:4*config.Fs))
title("First 4 sec of the channel output")

sgtitle("SNR = 40 dB")

%snr = 12 dB
figure
config.snrdB = 12;
subplot(2,1,1)
ChannelInVec = TX(config,infobits);
plot(ChannelInVec(1:4*config.Fs))
title("First 4 sec of the channel input")

subplot(2,1,2)
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
plot(ChannelOutVec(1:4*config.Fs))
title("First 4 sec of the channel output")
sgtitle("SNR = 12 dB")


[rxbits, filterOut] = RX(config,ChannelOutVec);
BER = mean(infobits ~= rxbits);


% Q 4

config.snrdB = 100; 
config.pulsetype = 0; 
ChannelInVec = TX(config,infobits);
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
[rxbits, filterOut] = RX(config,ChannelOutVec);


figure
plot(filterOut((config.Fs + length(txpulse)-4000):(config.Fs + length(txpulse)+4000)))
hold on
plot((config.Fs + length(txpulse)),filterOut(config.Fs + length(txpulse)) ,'rx') %plot a red x 

BER1 = mean(infobits ~= rxbits);



RefInputRect = load("RefInputRect.mat");

[rxbits,filterOut] = RX(config,RefInputRect.ChannelOutVec);
infobits = RefInputRect.infobits(:)';
BER2 = mean(infobits ~= rxbits);

SNR = (-12:3:12);
BERvec = zeros(1,length(SNR));

for i = 1:length(SNR)
    config.snrdB = SNR(i);
    ChannelInVec = TX(config,infobits);
    ChannelOutVec = ChannelTXRX(config,ChannelInVec);
    [rxbits, filterOut] = RX(config,ChannelOutVec);
    BERvec(i) = mean(infobits ~= rxbits);
end

figure
semilogy(SNR, BERvec);
title("BER vs SNR")



