clear all;
warning('off','all');

c = 5;
viola_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Viola';
violin_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Violin';

viola_names = dir(viola_path);
violin_names = dir(violin_path);

n_viola = length(viola_names)-2;
n_violin = length(violin_names)-2;

total = n_viola+n_violin;

temp_path = strcat(violin_path, '/Violin.arco.ff.sulA.Ab6.stereo.wav');
temp = kdmfcc(temp_path, c);
shape = size(temp);
mfcc_n = shape(1);
x = zeros(total, 8);%+mfcc_n);
y = zeros(total, 1);

for i=1:n_viola
    temp_path = strcat(viola_path, '/', viola_names(i+2).name);
    j = i;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = fundamental_freq(temp_path);
    x(j,3) = sc_variance(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    %x(j,9:8+mfcc_n) = kdmfcc(temp_path, c);
    y(j,1) = 0;
end
for i=1:n_violin
    temp_path = strcat(violin_path, '/', violin_names(i+2).name);
    j = i+n_viola;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = fundamental_freq(temp_path);
    x(j,3) = sc_variance(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    %x(j,9:8+mfcc_n) = kdmfcc(temp_path, c);
    y(j,1) = 1;
end

save('../string_classifier/data_x.mat', 'x')
save('../string_classifier/data_y.mat', 'y')
