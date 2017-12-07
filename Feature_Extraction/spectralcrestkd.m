function [vtsc] = spectralcrestkd (file_path)
   afWindow = hann(4096,'periodic');
   [in, f_s] =audioread(file_path);
    if (size(in, 2)==2)
        in = mean(in')';
    end
   x= spectrogram_dsp(in, afWindow, 4096-2048,4096,f_s);
    X = abs(x)*2/4096;

   vtsc1 = max(X,[],1) ./ sum(X,1);
   vrms =  sqrt(mean(X.^2));
   vtsc2=vtsc1.*vrms;
   
   vtsc=sum(vtsc2)./sum(vrms);
   
end