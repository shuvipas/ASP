function [ChannelOutVec] = ChannelTXRX(config,ChannelInVec)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    noise = randn(1, length(ChannelInVec)).*10^(-config.snrdB/20); %sigma = length(chanelInVec)*10^(-config.snrdB/20)
    ChannelOutVec = ChannelInVec + noise;



end
