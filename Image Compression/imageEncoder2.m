function [outputBitStream] = imageEncoder2(image, delta)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

ZigZag = load("ZigZagOrd.mat");

Image = imread(image);
BWimage = double(rgb2gray(Image));
[height, width] = size(BWimage);
M = 8;

%Scale from [0, 255] to [−0.5, 127/256] by subtracting 128 and then dividing by 256.
BWimageScale = (BWimage - 128)./256;

%Blocking is done by dividing the image into blocks of 8×8 (M = 8).
ImBlocks = zeros(M, M, height/M, width/M);

for i = 1:height/M
    for j = 1:width/M
        ImBlocks(:, :, i, j) = BWimageScale((M*(i-1) + 1:M*i), (M*(j-1) + 1:M*j));
    end
end

%DCT (Discrete-Cosine Transform)
for i = 1:height/M
    for j = 1:width/M
        ImBlocks(:, :, i, j) = dct2(ImBlocks(:, :, i, j));
    end
end

%Quantization is done by dividing by a constant δ and then rounding to the nearest integer
ImBlocks = round(ImBlocks./delta);

%We only use DPCM for the DC coefficients
%{
DPCM = ImBlocks;
for i = 1:height/M
    for j = 1:width/M
        if (j > 1)
            DPCM(1, 1, i, j) = ImBlocks(1, 1, i, j) - ImBlocks(1, 1, i, j-1); 
        end 
    end
end
%}

lastNZ_bit_stream = zeros(1, (height/M)*(width/M));
Gol_bitstream = strings(1, (height/M)*(width/M));

%The zigzag ordering
BlocksZigZag = zeros(M*M, height/M, width/M);
for i = 1:height/M
    for j = 1:width/M
        tmp = ImBlocks(:, :, i, j);
        tmp = reshape(tmp, [1, M*M]);
        for k = 1:M*M
            BlocksZigZag(k, i, j) = tmp(ZigZag.ZigZagOrd(k));
        end
    end
end

%Searching for the last non-zero element & Entropy coding
for i = 1:height/M
   for j = 1:width/M
       current_block = reshape(BlocksZigZag(:,i,j), [1, M*M]);
       current_lastNZ = find(current_block,1,'last');
       if isempty(current_lastNZ)
          current_lastNZ = 1;
       end
       index = sub2ind([height/M, width/M], i, j);
       bitsoflastNZ = dec2bin(current_lastNZ - 1, 6);
       lastNZ_bit_stream(1 + 6*(index-1):6*index) = bitsoflastNZ;
       current_Gol_bitstream = golomb_enc(current_block(1:current_lastNZ));
       Gol_bitstream(index) = current_Gol_bitstream;
   end
end

Gol_bitstream = convertStringsToChars(strjoin(Gol_bitstream, ""));
lastNZ_bit_stream = char(lastNZ_bit_stream);
outputBitStream = [Gol_bitstream lastNZ_bit_stream];
    
end