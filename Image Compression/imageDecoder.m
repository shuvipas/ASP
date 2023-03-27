function [decodedImage] = imageDecoder(inputBitStream, delta)
%This function takes a binary bitstream containing a compressed image 
% and a quantization step size delta, and decodes it into a grayscale image.
%Parameters:
%inputBitStream: This is a binary string that represents the compressed image data (It is the output of the imageEncoder).
%delta: The quantization step size.
%decodedImage: the restored image.


ZigZag = load("ZigZagOrd.mat");
M = 8;
height = 100;
width = 100;

%ImBlocks = zeros(M, M, height, width);
Blocks = zeros(1, M*M, height, width);
lastNZ_start = length(inputBitStream) - 6*height*width + 1;
startindex = 1;


for j = 1:width
    for i = 1:height
        current_lastNZ = bin2dec(inputBitStream(lastNZ_start:lastNZ_start + 5)) +1;

        temp = zeros(1, M*M);
        lastNZ_start  = lastNZ_start + 6;
        for m = 1:current_lastNZ
            [cursymbol, nextStartIndex] = golomb_dec(inputBitStream, startindex);
            startindex =  nextStartIndex;
            temp(m) = cursymbol;
        end
            Blocks(:,:, i, j) = temp;
    end
end

zigzag_Inv = zeros(M, M, height, width);
for i = 1:height
    for j = 1:width
        temp = Blocks(:,:, i, j);
        zigzag_Inv(:,:, i, j) = reshape(temp(ZigZag.ZigZagOrdInv), M, M);
    end
end


 
%zigzag_Inv =inputBitStream;

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
