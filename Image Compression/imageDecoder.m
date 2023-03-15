function [decodedImage, BWimage, ImBlocks] = imageDecoder(inputBitStream, delta)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

ZigZag = load("ZigZagOrd.mat");
M = 8;
height = 100;
width = 100;

ImBlocks = zeros(M, M, height, width);

for index = 1:height*width
    startPoint = length(inputBitStream) - 6*height*width + 1;
    current_lastNZ = bin2dec(inputBitStream(startPoint + 6*(index-1):6*index));
    current_block = zeros(1, M*M);
    
    for symbol = 1:current_lastNZ
        [cursymbol, nextstratindex] = golomb_dec(inputBitStream(1:length(inputBitStream) - 6*height*width), stratindex);
        current_block(symbol) = cursymbol;
        stratindex = nextstratindex;    
    end
    
    ZigZag_inv = reshape(current_block(ZigZag.ZigZagOrdInv), M, M);
    
    i = floor(index / height);
    j = mod(index, width);
    ImBlocks(:, :, i+1, j+1) = ZigZag_inv(:, :);
end

%Inverse quantization
ImBlocks = ImBlocks.*delta;

%Inverse DPCM
for i = 1:height
    for j = 1:width
        if (j > 1)
            ImBlocks(1, 1, i, j) = ImBlocks(1, 1, i, j) + ImBlocks(1, 1, i, j-1); 
        end 
    end
end

%Inverse DCT
for i = 1:height
    for j = 1:width
        ImBlocks(:, :, i, j) = idct2(ImBlocks(:, :, i, j));
    end
end

BWimage = zeros(800, 800);

%Deblocking
for i = 1:height
    for j = 1:width
        BWimage((M*(i-1) + 1:M*i), (M*(j-1) + 1:M*j)) = ImBlocks(:, :, i, j);
    end
end

%Scaling
decodedImage = BWimage.*256 + 128;

end
