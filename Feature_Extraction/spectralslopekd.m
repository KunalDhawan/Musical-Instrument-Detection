function [vssl] = spectralslopekd (file_path)

	afWindow = hann(4096,'periodic');
	[in, f_s] =audioread(file_path);
	if (size(in, 2)==2)
	in = mean(in')';
	end
	x = spectrogram_dsp(in, afWindow, 4096-2048,4096,f_s);
	X = abs(x)*2/4096;

	mu_x    = mean(abs(X), 1);

	% compute index vector
	kmu     = [0:size(X,1)-1] - size(X,1)/2;

	% compute slope
	X       = X - repmat(mu_x, size(X,1), 1);
	vssl1    = (kmu*X)/(kmu*kmu');
	vrms =  sqrt(mean(X.^2));
	vssl2=vssl1.*vrms;

	vssl=sum(vssl2)./sum(vrms);

end
