function [vssk] = spectralskewnesskd (file_path)

	afWindow = hann(4096,'periodic');
	[in, f_s] =audioread(file_path);
	if (size(in, 2)==2)
		in = mean(in')';
	end
	x = spectrogram_dsp(in, afWindow, 4096-2048,4096,f_s);
	X = abs(x)*2/4096;

	mu_x    = mean(abs(X), 1);
	std_x   = std(abs(X), 1);
	X       = X - repmat(mu_x, size(X,1), 1);
	vssk1    = sum ((X.^3)./(repmat(std_x, size(X,1), 1).^3*size(X,1)));

	vrms =  sqrt(mean(X.^2));
	vssk2=vssk1.*vrms;
	vssk=sum(vssk2)./sum(vrms);
end

