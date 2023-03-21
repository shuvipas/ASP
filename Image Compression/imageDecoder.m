function [decodedImage] = imageDecoder(inputBitStream, delta)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

ZigZag = load("ZigZagOrd.mat");
M = 8;
height = 100;
width = 100;

%ImBlocks = zeros(M, M, height, width);
Blocks = zeros(1, M*M, height, width);
lastNZ_start = length(inputBitStream) - 6*height*width + 1;
startindex = 1;


%first option
%{
longblock = zeros(64,10000);
stratindex = 1;
lenvec = length(inputBitStream);
fullalllastNZ = inputBitStream(lenvec-59999:end);% we will put lastNZ_bit_stream into seperate vector
alllastNZ = zeros(1,10000);
for w = (1:6:59995)
    alllastNZ((w-1)/6+1) = bin2dec(fullalllastNZ(w:w+5)); % we will have NZ as decimal
end
for j = (1:10000)
   
    current_lastNZ = alllastNZ(j);
     for symbol=1:current_lastNZ+1       
        [cursymbol, nextstratindex] = golomb_dec(inputBitStream(1:lenvec-60000), stratindex);
        stratindex = nextstratindex;      
        longblock(symbol,j) = cursymbol;
     end
    

end

unzigzag = zeros(64,100,100);
for s = (1:100)
    for r = (1:100)
        unzigzag(:,s,r)= longblock(:,(s-1)*100+r);
    end
end
unBlocks = zeros(8,8,100,100);
for i = (1:100) 
    for j = (1:100)
        place = 0;
        temp =  zeros(8,8); %put block into seprate matrix
        for w = ZigZagOrdInv
            place = place +1;
            temp(place) = unzigzag(w,i,j);
        end
            unBlocks(:,:,i,j) = temp;
    end
end
zigzag_Inv = unBlocks;
%}


for i = 1: height
    for j = 1:width
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

% 3rd option
%{
for index = 1:height*width
    %current_lastNZ = bin2dec(inputBitStream(lastNZ_start + 6*(index-1):lastNZ_start + 6*index));
    current_lastNZ = bin2dec(inputBitStream(lastNZ_start:lastNZ_start + 5)) +1;
    current_Gol_bitstream = inputBitStream(index);
    [i, j] = ind2sub([height, width], index);
    temp = zeros(1, M*M);
    for symbol = 1:current_lastNZ
        [cursymbol, nextStartIndex] = golomb_dec(current_Gol_bitstream, startindex);
        startindex = nextStartIndex;
        temp(symbol) = cursymbol;
        %Blocks(symbol, i, j) = cursymbol;
    end
    Blocks(:,:, i, j) = temp;
end
%}

zigzag_Inv = zeros(M, M, height, width);
for i = 1:height
    for j = 1:width
        temp = Blocks(:,:, i, j);
        zigzag_Inv(:,:, i, j) = reshape(temp(ZigZag.ZigZagOrdInv), M, M);
%{
        ZigZag_inv = zeros(1, M*M);
        for k = 1:M*M
            ZigZag_inv(k) = Blocks(ZigZag.ZigZagOrdInv(k), i, j);
        end
        zigzag_Inv(:, :, i, j) = reshape(ZigZag_inv, [M, M]);
%}    
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
