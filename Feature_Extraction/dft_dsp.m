function X = dft_dsp(x)
    % Implements conventional unoptimised dft
    len = length(x);
    X = zeros(1, len);
    for index=1:len
        w = exp(1i*2*pi*(index-1)/len);
        X(index) = 0;
        for x_index=1:len
            X(index) = X(index) + x(x_index)*(w^(x_index-1));
        end
    end
    X = abs(X);
end