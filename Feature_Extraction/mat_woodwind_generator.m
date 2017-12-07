clear all;
warning('off','all');

c = 5;
oboe_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Oboe';
flute_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Flute';
clarinet_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/EbClarinet';
saxophone_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Saxophone';

oboe_names = dir(oboe_path);
flute_names = dir(flute_path);
clarinet_names = dir(clarinet_path);
saxophone_names = dir(saxophone_path);

n_oboe = length(oboe_names)-2;
n_flute = length(flute_names)-2;
n_clarinet = length(clarinet_names)-2;
n_saxophone = length(saxophone_names)-2;

total = n_oboe+n_flute+n_clarinet+n_saxophone;

temp_path = strcat(oboe_path, '/Oboe.ff.A5.stereo.wav');
temp = kdmfcc(temp_path, c);
shape = size(temp);
mfcc_n = shape(1);
x = zeros(total, 8+mfcc_n);
y = zeros(total, 1);

for i=1:n_oboe
    temp_path = strcat(oboe_path, '/', oboe_names(i+2).name);
    j = i;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = fundamental_freq(temp_path);
    x(j,3) = sc_variance(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    x(j,9:8+mfcc_n) = kdmfcc(temp_path, c);
    y(j,1) = 0;
end
for i=1:n_flute
    temp_path = strcat(flute_path, '/', flute_names(i+2).name);
    j = i+n_oboe;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = fundamental_freq(temp_path);
    x(j,3) = sc_variance(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    x(j,9:8+mfcc_n) = kdmfcc(temp_path, c);
    y(j,1) = 1;
end
for i=1:n_clarinet
    temp_path = strcat(clarinet_path, '/', clarinet_names(i+2).name);
    j = i+n_oboe+n_flute;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = fundamental_freq(temp_path);
    x(j,3) = sc_variance(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    x(j,9:8+mfcc_n) = kdmfcc(temp_path, c);
    y(j,1) = 2;
end
for i=1:n_saxophone
    temp_path = strcat(saxophone_path, '/', saxophone_names(i+2).name);
    j = i+n_oboe+n_flute+n_clarinet;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = fundamental_freq(temp_path);
    x(j,3) = sc_variance(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    x(j,9:8+mfcc_n) = kdmfcc(temp_path, c);
    y(j,1) = 1;
end
save('../woodwind_classifier/data_x.mat', 'x')
save('../woodwind_classifier/data_y.mat', 'y')
