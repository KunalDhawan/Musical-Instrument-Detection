clear all;
warning('off','all');
%{
STRING : 1)Viola
         2)Violin
BRASS : 1)Trumpet
        2)TenorTrombone
        3)Tuba
        4)Horn
WOODWIND : 1)Saxophone
           2)EbClarinet
           3)Oboe
           4)Flute
%}
violin_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Violin';
viola_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Viola';
tuba_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Tuba';
tenor_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/TenorTrombone';
trumpet_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Trumpet';
oboe_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Oboe';
horn_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Horn';
flute_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Flute';
clarinet_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/EbClarinet';
saxophone_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Saxophone';

violin_names = dir(violin_path);
viola_names = dir(viola_path);
tuba_names = dir(tuba_path);
tenor_names = dir(tenor_path);
trumpet_names = dir(trumpet_path);
oboe_names = dir(oboe_path);
horn_names = dir(horn_path);
flute_names = dir(flute_path);
clarinet_names = dir(clarinet_path);
saxophone_names = dir(saxophone_path);

n_violin = length(violin_names)-2;
n_viola = length(viola_names)-2;
n_tuba = length(tuba_names)-2;
n_tenor = length(tenor_names)-2;
n_trumpet = length(trumpet_names)-2;
n_oboe = length(oboe_names)-2;
n_horn = length(horn_names)-2;
n_flute = length(flute_names)-2;
n_clarinet = length(clarinet_names)-2;
n_saxophone = length(saxophone_names)-2;

total = n_violin + n_viola + n_tuba+n_tenor+n_trumpet + n_oboe + n_horn + n_flute+n_clarinet+n_saxophone;

x = zeros(total, 8);
y = zeros(total, 1);

for i=1:n_violin
    temp_path = strcat(violin_path, '/', violin_names(i+2).name);
    x(i,1) = spec_centroid(temp_path);
    x(i,2) = zero_cross(temp_path);
    x(i,3) = spec_roll(temp_path);
    x(i,4) = spectralcrestkd(temp_path);
    x(i,5) = spectraldecreasekd(temp_path);
    x(i,6) = spectralflatnesskd(temp_path);
    x(i,7) = spectralskewnesskd(temp_path);
    x(i,8) = spectralslopekd(temp_path);
    y(i,1) = 0;
end
for i=1:n_viola
    temp_path = strcat(viola_path, '/', viola_names(i+2).name);
    x(i+n_violin,1) = spec_centroid(temp_path);
    x(i+n_violin,2) = zero_cross(temp_path);
    x(i+n_violin,3) = spec_roll(temp_path);
    x(i+n_violin,4) = spectralcrestkd(temp_path);
    x(i+n_violin,5) = spectraldecreasekd(temp_path);
    x(i+n_violin,6) = spectralflatnesskd(temp_path);
    x(i+n_violin,7) = spectralskewnesskd(temp_path);
    x(i+n_violin,8) = spectralslopekd(temp_path);
    y(i+n_violin,1) = 0;
end
for i=1:n_trumpet
    temp_path = strcat(trumpet_path, '/', trumpet_names(i+2).name);
    j = i+n_violin+n_viola;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 1;
end
for i=1:n_tenor
    temp_path = strcat(tenor_path, '/', tenor_names(i+2).name);
    j = i+n_violin+n_viola+n_trumpet;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 1;
end
for i=1:n_tuba
    temp_path = strcat(tuba_path, '/', tuba_names(i+2).name);
    j = i+n_violin+n_viola+n_trumpet+n_tenor;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 1;
end
for i=1:n_horn
    temp_path = strcat(horn_path, '/', horn_names(i+2).name);
    j = i+n_violin+n_viola+n_trumpet+n_tenor+n_tuba;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 1;
end
for i=1:n_saxophone
    temp_path = strcat(saxophone_path, '/', saxophone_names(i+2).name);
    j = i+n_violin+n_viola+n_trumpet+n_tenor+n_tuba+n_horn;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 2;
end
for i=1:n_clarinet
    temp_path = strcat(clarinet_path, '/', clarinet_names(i+2).name);
    j = i+n_violin+n_viola+n_trumpet+n_tenor+n_tuba+n_horn+n_saxophone;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 2;
end
for i=1:n_oboe
    temp_path = strcat(oboe_path, '/', oboe_names(i+2).name);
    j = i+n_violin+n_viola+n_trumpet+n_tenor+n_tuba+n_horn+n_saxophone+n_clarinet;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 2;
end
for i=1:n_flute
    temp_path = strcat(flute_path, '/', flute_names(i+2).name);
    j = i+n_violin+n_viola+n_trumpet+n_tenor+n_tuba+n_horn+n_saxophone+n_clarinet+n_oboe;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
    y(j,1) = 2;
end

save('../data_x_10inst.mat', 'x')
save('../data_y_10inst.mat', 'y')
