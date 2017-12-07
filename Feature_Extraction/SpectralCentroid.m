function sc = SpectralCentroid(file_name)
    %Loading the file containing audio sample
    [temp, f]=audioread(file_name);
    if (size(temp, 2)==2)
        y = mean(temp')';
    end
    Y_spectrum=abs(fft_radix2(y'));
    Y_spectrum= Y_spectrum';
    Y_spectrum= Y_spectrum.^2;
    length = ceil(size(Y_spectrum,1))/2;
    Y = Y_spectrum(1:length,:);
    sc = ([0:length-1]*Y)./sum(Y,1);
    sc = (sc/size(Y,1))*22050;
end
