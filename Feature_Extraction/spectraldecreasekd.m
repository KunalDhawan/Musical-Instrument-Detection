function [vsd] = spectraldecreasekd (file_path)
   afWindow = hann(4096,'periodic');
   [in, f_s] =audioread(file_path); 
    if (size(in, 2)==2)
        in = mean(in')';
    end
    x = spectrogram_dsp(in, afWindow, 4096-2048,4096,f_s);
    X = abs(x)*2/4096;
    
    % compute index vector
    k       = [0:size(X,1)-1];
    k(1)    = 1;
    kinv    = 1./k;
    
    % compute slope
    vsd1     = (kinv*(X-repmat(X(1,:),size(X,1),1)))./sum(X(2:end,:),1);
    vrms =  sqrt(mean(X.^2));
   vsd2=vsd1.*vrms;
   
   vsd=sum(vsd2)./sum(vrms);
%         dlmwrite('spectraldecrease.txt', vsd, 'delimiter', '\t');
end