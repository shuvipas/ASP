
delta = 0.001;
load("ZigZagOrd.mat");
outputBitStream = imageEncoder("cat800x800.bmp", delta);
[decodedImage, BWimage] = imageDecoder(outputBitStream, delta);
imshow(uint8(decodedImage))




