function [y] = spectrogram_dsp(in, afWindow, n_overlap, n_freq, f_s)
    % n_overlap - specifies number of samples of overlap between adjoining sections
    % n_freq - number of frequencies at which values are returned

    temp = fix((length(in) - n_overlap) / (length(afWindow) - n_overlap));
    x = zeros(n_freq, temp);
    for index=1:temp
        sample = in( ((index-1)*(length(afWindow)-n_overlap) + 1):(index*length(afWindow)-(index-1)*n_overlap) );
        sample = sample .* afWindow;
        x(:,index) = fft_radix2(sample);
    end
    % return the first length(dfWindow)/2 + 1 terms since fft has symmetry X*(m) = X(N-m)
    y = x(1:(length(dfWindow)/2 + 1), :);
end
