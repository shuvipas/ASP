clear all
clc

config = load("config.mat").config;
config.pulsetype = 1; % 1 for sinc,  0 for rect
config.K = 1e4;
config.synch = 0; % 0 for without the synchronization mechanism, 1 with it.
config.mod = 0;% 0 without modulation, 1 with.

infobits = rand(1,config.ninfobits)>0.5; %making bernuli vector


% Q 2

rectL2norm = sum(config.tpulserect.^2);
plot(config.tpulserect)
str = sprintf("pulse rect, L2 norm = %g", rectL2norm);
title(str)


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


figure
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
ChannelInVec = TX1(config,infobits);
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
ChannelInVec = TX1(config,infobits);
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
ChannelInVec = TX1(config,infobits);
plot(ChannelInVec(1:4*config.Fs))
title("First 4 sec of the channel input")

subplot(2,1,2)
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
plot(ChannelOutVec(1:4*config.Fs))
title("First 4 sec of the channel output")
sgtitle("SNR = 12 dB")


[rxbits, filterOut] = RX1(config,ChannelOutVec);
BER = mean(infobits ~= rxbits);

% Q 4

config.snrdB = 100; 
config.pulsetype = 0; %rect
ChannelInVec = TX1(config,infobits);
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
[rxbits, filterOut] = RX1(config,ChannelOutVec);


figure
plot(filterOut((config.Fs + length(txpulse)-4000):(config.Fs + length(txpulse)+4000)))
hold on
plot(config.Fs + length(txpulse) ,filterOut(config.Fs + length(txpulse)) ,'rx') %plot a red x 
title("output of the matched filter")
hold off
BER1 = mean(infobits ~= rxbits);



RefInputRect = load("RefInputRect.mat");

[rxbits,filterOut] = RX1(config,RefInputRect.ChannelOutVec);
infobits = RefInputRect.infobits(:)';
BER2 = mean(infobits ~= rxbits);

SNRrect = (-12:3:12);
BERrect = zeros(1,length(SNRrect));

for i = 1:length(SNRrect)
    config.snrdB = SNRrect(i);
    ChannelInVec = TX1(config,infobits);
    ChannelOutVec = ChannelTXRX(config,ChannelInVec);
    [rxbits, filterOut] = RX1(config,ChannelOutVec);
    BERrect(i) = mean(infobits ~= rxbits);
end

figure
semilogy(SNRrect, BERrect);
title("BER vs SNR")
subtitle("rect")
xlabel("SNR")
ylabel("BER")

%}
config.pulsetype = 1; % sinc as default
config.snrdB = 100;

%q 4.d

RefInputSinc = load("RefInputSinc.mat");

config.snrdB = 100;
config.pulsetype = 1; %sinc

[rxbits,filterOut] = RX1(config,RefInputSinc.ChannelOutVec);
infobits = RefInputSinc.infobits(:)';
BER3 = mean(infobits ~= rxbits);

SNRsinc = (-12:3:12);
BERsinc = zeros(1,length(SNRsinc));

for i = 1:length(SNRsinc)
    config.snrdB = SNRsinc(i);
    ChannelInVec = TX1(config,infobits);
    ChannelOutVec = ChannelTXRX(config,ChannelInVec);
    [rxbits, filterOut] = RX1(config,ChannelOutVec);
    BERsinc(i) = mean(infobits ~= rxbits);
end

figure
semilogy(SNRsinc, BERsinc);
title("BER vs SNR")
subtitle("sinc")
xlabel("SNR")
ylabel("BER")



%Q 5.c

config.snrdB = 100;
config.synch = 1; % with the synchronization mechanism 
config.pulsetype = 1; %sinc
synchbits = config.synchbits(:)';
infobits = rand(1,config.ninfobits)>0.5; %making bernuli vector

ChannelInVec = TX1(config,[synchbits, infobits]);
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
[rxbits, filterOut] = RX1(config,ChannelOutVec);

BERsynch = mean(infobits ~= rxbits);


%Q 5.d

config.pulsetype = 1;
config.synch = 1;

RefInputSynch = load("RefInputSynch.mat");
[rxbits, filterOut] = RX1(config,RefInputSynch.ChannelOutVec);
infobits = RefInputSynch.infobits(:)';
BER5d = mean(infobits ~= rxbits);


% Q 5.e

SNR5e = (-12:3:12);
BER5e = zeros(1,length(SNR5e));

for i = 1:length(SNR5e)
    config.snrdB = SNR5e(i);
    ChannelInVec = TX1(config,[config.synchbits, infobits]);
    ChannelOutVec = ChannelTXRX(config,ChannelInVec);
    [rxbits, filterOut] = RX1(config,ChannelOutVec);
    BER5e(i) = mean(infobits ~= rxbits);
end

figure
semilogy(SNR5e, BER5e);
title("BER vs SNR")
subtitle("synchronization mechanism")
xlabel("SNR")
ylabel("BER")

config.snrdB = 100;
% Q 6

%q 6.a
config.mod = 1; 
config.synch = 1; % with the synchronization mechanism 
config.pulsetype = 1; %sinc
synchbits = config.synchbits(:)';
infobits = rand(1,config.ninfobits)>0.5; %making bernuli vector

ChannelInVec = TX1(config,[synchbits, infobits]);
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
[rxbits, filterOut] = RX1(config,ChannelOutVec);

BERmod = mean(infobits ~= rxbits);


%q 6.b
RefInputMod = load("RefInputMod.mat");
[rxbits,filterOut, halfBetta] = RX1(config,RefInputMod.ChannelOutVec);
infobits = RefInputMod.infobits(:)';
BERrefmod = mean(infobits ~= rxbits);


%q 6.c
SNR6 = (-12:3:12);
BER6 = zeros(1,length(SNR6));

for i = 1:length(SNR6)
    config.snrdB = SNR6(i);
    ChannelInVec = TX1(config,[config.synchbits, infobits]);
    ChannelOutVec = ChannelTXRX(config,ChannelInVec);
    [rxbits, filterOut] = RX1(config,ChannelOutVec);
    BER6(i) = mean(infobits ~= rxbits);
end

figure
semilogy(SNR6, BER6);
title("BER vs SNR")
subtitle("modulation")
xlabel("SNR")
ylabel("BER")
