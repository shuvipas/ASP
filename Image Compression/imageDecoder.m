
function [decodedImage, BWimage] = imageDecoder(inputBitStream, delta)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

ZigZag = load("ZigZagOrd.mat");
M = 8;
height = 100;
width = 100;


ImBlocks = zeros(M, M, height, width);

%{
for index = 1:height*width
    startPoint = length(inputBitStream) - 6*height*width + 1;
    current_lastNZ = bin2dec(inputBitStream(startPoint + 6*(index-1):6*index));
    current_block = zeros(1, M*M);
    
    for symbol = 1:current_lastNZ
        [cursymbol, nextstratindex] = golomb_dec(inputBitStream(1:length(inputBitStream) - 6*height*width), stratindex);
        current_block(symbol) = cursymbol;
        stratindex = nextstratindex;    
    end


    %ZigZag_inv = reshape(current_block(ZigZag.ZigZagOrdInv), M, M);
    for i = 1:height
        for j = 1:width

             ZigZag_inv =inputBitStream; %B_zigZag;

    i = floor(index / height);
    j = mod(index, width);
               ImBlocks(:, :, i, j) = ZigZag_inv(:, i, j);
        end
    end
%}
for index = 1:height*width
    startPoint = length(inputBitStream) - 6*height*width + 1;
    current_lastNZ = bin2dec(inputBitStream(startPoint + 6*(index-1):startPoint +6*index - 1));
    current_block = zeros(1, M*M);
    
    for symbol = 1:current_lastNZ
        
        [cursymbol, nextstratindex] = golomb_dec(inputBitStream, stratindex);
        
       %[cursymbol, nextstratindex] = golomb_dec(inputBitStream(1:length(inputBitStream) - 6*height*width), stratindex);
        current_block(symbol) = cursymbol;
        stratindex = nextstratindex;    
    end
    newCurrBlock = current_block(ZigZag.ZigZagOrdInv);
    ZigZag_inv = reshape(newCurrBlock, M, M);
    


    i = floor(index / height);
    j = mod(index, width);
    ImBlocks(:, :, i+1, j+1) = ZigZag_inv(:, :);
end

%Inverse quantization
ImBlocks = ImBlocks.*delta;


%Inverse DPCM
DPCMinv = ImBlocks;

for i = 1:height
    for j = 1:width
        if (j > 1)
            DPCMinv(1, 1, i, j) = ImBlocks(1, 1, i, j) + DPCMinv(1, 1, i, j-1); 
        end 
    end
end


%Inverse DCT
DCTinv = DPCMinv; 
for i = 1:height
    for j = 1:width
        DCTinv(:, :, i, j) = idct2(DCTinv(:, :, i, j));
    end
end

BWimage = zeros(800, 800);

%Deblocking
for i = 1:height
    for j = 1:width
        BWimage((M*(i-1) + 1:M*i), (M*(j-1) + 1:M*j)) = DCTinv(:, :, i, j);
    end
end

%Scaling
decodedImage = BWimage.*256 + 128;

end
