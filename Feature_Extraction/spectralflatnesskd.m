function [vtf] = spectralflatnesskd (file_path)
   afWindow = hann(4096,'periodic');
   [in, f_s] =audioread(file_path);
   if (size(in, 2)==2)
        in = mean(in')';
   end
   x = spectrogram_dsp(in, afWindow, 4096-2048,4096,f_s);
    X = abs(x)*2/4096;
 
    XLog    = log(X+1e-20);
    vtf1     = exp(mean(XLog,1)) ./ mean(X,1);
    
     vrms =  sqrt(mean(X.^2));
   vtf2=vtf1.*vrms;
   
   vtf=sum(vtf2)./sum(vrms);
end