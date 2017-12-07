function sro_hz = SpectralRollOff(file_name)
	[temp, f]=audioread(file_name);
	if (size(temp, 2)==2)
		y = mean(temp')';
	end
	
	%Calculating SpectralRollOff Frequency for the audio file
	threshold = 0.85;
	Y_spectrum=abs(fft_radix2(y'));
	Y_spectrum= Y_spectrum';
	length = size(Y_spectrum,1);
	all_sum = sum(Y_spectrum)/2; 
	sro = find(cumsum(Y_spectrum)>=threshold*all_sum,1);
	sro_hz = (sro*f)/length;
end
