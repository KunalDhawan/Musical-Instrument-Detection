function val = ZeroCrossingRate(filename) 
	
	[temp, f]=audioread(filename);
	if (size(temp, 2)==2)
	    y = mean(temp')';
	end
	
	%Calculating Zero Crossing Rate for the audio file
	length = size(y,1);
	zcr_sum = 0.5*sum(abs(diff(sign(y(1:length)))));
	val = zcr_sum/(length/44100); %Finding Zero Crossing Rate per second
end
