function [decodedImage] = imageDecoder(inputBitStream, delta)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

ZigZag = load("ZigZagOrd.mat");
M = 8;
height = 100;
width = 100;

ImBlocks = zeros(M, M, height, width);
Blocks = zeros(M*M, height, width);
lastNZ_start = length(inputBitStream) - 6*height*width;
startindex = 1;
for index = 1:height*width
    current_lastNZ = bin2dec(inputBitStream(lastNZ_start + 6*(index-1):lastNZ_start + 6*index));
    current_Gol_bitstream = inputBitStream(index);
    [i, j] = ind2sub([height, width], index);
    for symbol = 1:current_lastNZ
        [cursymbol, nextstartindex] = golomb_dec(current_Gol_bitstream, startindex);
        startindex = nextstartindex;
        Blocks(symbol, i, j) = cursymbol;
    end
end
    
zigzag_Inv = zeros(M, M, height, width);
for i = 1:height
    for j = 1:width
        ZigZag_inv = zeros(1, M*M);
        for k = 1:M*M
            ZigZag_inv(k) = Blocks(ZigZag.ZigZagOrdInv(k), i, j);
        end
        zigzag_Inv(:, :, i, j) = reshape(ZigZag_inv, [M, M]);
    end
end
  
%Inverse quantization
ImBlocks = zigzag_Inv.*delta;

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
