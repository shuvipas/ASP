clc
clear all
load('config.mat')

strvec = 'Communication is fun!!!  ';  % exactly 25 characters
infobits = (text2bitstream(strvec))';
config.K = length(infobits);  

infobits = (text2bitstream(strvec))';
ChannelInVec = TX(config,[config.synchbits infobits]);
ChannelOutVec = ChannelTXRXAudio(config,ChannelInVec);
rxbits = RX(config,ChannelOutVec');
strvec = bitstream2text(rxbits)
