function [result] = FundamentalFrequency(filename)
    [x, fs] = audioread(filename);
    %%
    %Check for mono or stereo input audio file
    [a,b] = size(x);
    if b>1
        x = (x(:,1)+x(:,2))/2;
    end
    %%
    %Each audio file consists of single note, hence fundamental frequency 
    %is mainly observed within a window of 0.1 to 0.25 seconds, that can  
    %be checked by doing Spectrogram Analysis
    
    dt = 1/fs;
    Istart = round(0.1/dt);
    Iend = round(0.25/dt);
    y = x(Istart:Iend);
    
    %%
    
    c = cceps(y); %Computing complex cepstrum
    
    %%
    %Select a time range between 1.5 & 15 ms, corresponding to a frequency 
    %range of approximately 200 to 700 Hz. Identify the tallest peak of the
    %cepstrum in the selected range. Find the frequency corresponding to 
    %the peak. Use the peak as the estimate of the fundamental frequency.
    
    t = 0:dt:length(y)*dt-dt;

    trange = t(t>=1.5e-3 & t<=15e-3);
    crange = c(t>=1.5e-3 & t<=15e-3);

    [~,Z] = max(crange);
    result = 1/trange(Z);    
end
