clear all;
warning('off','all');

trumpet_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav/Trumpet';
tenor_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/TenorTrombone';
tuba_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav_new/Tuba';
horn_path = '/home/jayanth/Desktop/dsp_project/data/data_in_wav/Horn';

trumpet_names = dir(trumpet_path);
tenor_names = dir(tenor_path);
tuba_names = dir(tuba_path);
horn_names = dir(horn_path);

n_trumpet = length(trumpet_names)-2;
n_tenor = length(tenor_names)-2;
n_tuba = length(tuba_names)-2;
n_horn = length(horn_names)-2;

total = n_trumpet + n_horn + n_tuba + n_tenor;

x = zeros(total, 8);
y = zeros(total, 1);

for i=1:n_trumpet
    temp_path = strcat(trumpet_path, '/', trumpet_names(i+2).name);
    j = i;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);
   
    y(j,1) = 0;
end
for i=1:n_horn
    temp_path = strcat(horn_path, '/', horn_names(i+2).name);
    j = i+n_trumpet;
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
    j = i + n_trumpet + n_horn;
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
for i=1:n_tuba
    temp_path = strcat(tuba_path, '/', tuba_names(i+2).name);
    j = i + n_trumpet + n_horn + n_tenor;
    x(j,1) = spec_centroid(temp_path);
    x(j,2) = zero_cross(temp_path);
    x(j,3) = spec_roll(temp_path);
    x(j,4) = spectralcrestkd(temp_path);
    x(j,5) = spectraldecreasekd(temp_path);
    x(j,6) = spectralflatnesskd(temp_path);
    x(j,7) = spectralskewnesskd(temp_path);
    x(j,8) = spectralslopekd(temp_path);

    y(j,1) = 3;
end

save('../brass_classifier/4_inst/data_x_8features.mat', 'x')
save('../brass_classifier/4_inst/data_y_8features.mat', 'y')
