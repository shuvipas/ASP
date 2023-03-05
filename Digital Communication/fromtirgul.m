config.load("config.mat").config;

config.K =1e4;

infobits = rand(1,config.ninfobits)>0.5; %making bernuli vector
BPSKbits = 1-2*infobits; %making bernuli vector



pulseTrain = kpsample(BPSKbits, config.TS);%making the pulse train

txpulse = config.tpulserect;
%or depens if we use rect or sinc
txpulse = config.tpulsesinc;

TxFilterOut = conv(txpulse, pulseTrain);

chanelInVec = [zeros(1, config.Fs) TxFilterOut zeros(4, config.Fs)]; %for the quit times

config.snrdB = 100; %100/40/12  dB 
% depans on the quastion paramerters

Noise.vec = randn(1, length(chanelInVec)*10^(-config.snrdB/20)); %sigma =length(chanelInVec)*10^(-config.snrdB/20)

chanelOutVec = chanelInVec + Noise.vec;


% Bounes quastion min 35 in the tirgul




 









