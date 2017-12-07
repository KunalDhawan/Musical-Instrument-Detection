function [result] = VarianceSpectralCentroid(file_name)
    %%
    %This function computes the variance of an array consisting of spectral
    %centroid of short term frames of the whole input audio file
    
    %%
    
    [x, fs]=audioread(file_name);
    %Check for mono or stereo input audio file
    [a,b] = size(x);
    if b>1
        x = (x(:,1)+x(:,2))/2;
    end
    
    %%
    %Computing Spectrogram
    afWindow = hann(4096,'periodic');
        
    [x,f,t]= spectrogram(x, afWindow, 4096-2048,4096,fs);
    X = abs(x)*2/4096;
    
    X = X.^2;
    %%
    
    %Spectral Centroid Computation
    SC = ([0:size(X,1)-1]*X)./sum(X,1);
    
    %Avoiding NaN of silent short term frames
    SC (sum(X,1) == 0) = 0;
        
    %Converting from index to Hertz
    SC = SC / size(X,1) * fs/2;
    
    %%
    
    %Variance of spectral centroid 
    result = var(SC');
end
