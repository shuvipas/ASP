
delta =[0.5, 0.1, 0.01, 0.001];
images = ["cat800x800.bmp" "flower800x800.bmp" "zakir800x800.bmp" "shades800x800.bmp"];
psnrMat = zeros(length(images), length(delta));
sizeDesMat= zeros(length(images), length(delta));
JPEGbenchmark = load("JPEGbenchmark.mat");

psnrMat2 = zeros(length(images), length(delta));
sizeDesMat2= zeros(length(images), length(delta));

for i = 1:length(images)
    for d = 1:length(delta)    
        Image = imread(images(i));
        BWimage = double(rgb2gray(Image));
        outputBitStream = imageEncoder(images(i), delta(d));
        decodedImage = imageDecoder(outputBitStream, delta(d));
        MSE = immse(BWimage, decodedImage);
        sizeDesMat(i,d) = length(outputBitStream)/(800*800);
        psnrMat(i,d) = 10*log10(255/sqrt(MSE));
              
        if delta(d) == 0.5
            figure
            imshow(uint8(decodedImage))
        end
        
        outputBitStream2 = imageEncoder2(images(i), delta(d));
        decodedImage2 = imageDecoder2(outputBitStream2, delta(d));
        MSE2 = immse(BWimage, decodedImage2);
        sizeDesMat2(i,d) = length(outputBitStream2)/(800*800);
        psnrMat2(i,d) = 10*log10(255/sqrt(MSE2));
        
    end
end

jpegBenchPsnr = [JPEGbenchmark.catPSNRvecJpeg; JPEGbenchmark.flowerPSNRvecJpeg; JPEGbenchmark.zakirPSNRvecJpeg; JPEGbenchmark.shadesPSNRvecJpeg];
jpegBenchSize = [JPEGbenchmark.catSizevecJpeg; JPEGbenchmark.flowerSizevecJpeg; JPEGbenchmark.zakirSizevecJpeg; JPEGbenchmark.shadesSizevecJpeg];
for i = 1:length(images)
    str = sprintf("%s",images(i));
    
    figure
    plot(jpegBenchSize(i,:), jpegBenchPsnr(i,:));
    title("PSNR vs. bpp of the Matlab’s embedded compression engine")
    subtitle(str)
    xlabel("bits per pixel")
    ylabel("PSNR")

    
    figure
    plot(sizeDesMat(i,:), psnrMat(i,:));
    title("PSNR vs. bpp of our Matlab compression");
    subtitle(str)
    xlabel("bits per pixel")
    ylabel("PSNR")
    
    figure
    plot(sizeDesMat2(i,:), psnrMat2(i,:));
    title("PSNR vs. bpp of our Matlab without DPCM");
    subtitle(str)
    xlabel("bits per pixel")
    ylabel("PSNR")
    
end


