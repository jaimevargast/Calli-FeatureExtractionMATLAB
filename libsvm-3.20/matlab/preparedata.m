clear all
close all

labels_folder = '..\..\labels';
features_folder = '..\..\letters and features\synthetic s';
output_folder = 'SVMData\';
labels_file = 's_synthetic.mat';
mapping_file = 'mapping_s_synthetic.mat';
output_file = 's_synthetic_svmdata.txt';

% loading lables, mapping, features
load(fullfile(labels_folder, labels_file));
load(fullfile(labels_folder, mapping_file));
fsd_files = dir(fullfile(features_folder, 'fourier shape descriptors', '*.mat')); %60
hmd_files = dir(fullfile(features_folder, 'Hu moments descriptor', '*.mat')); %7
cc_files = dir(fullfile(features_folder, 'Chain code', '*.mat')); %50
kp_files = dir(fullfile(features_folder, 'keypoint descriptors', '*.mat')); %208
concavity_files = dir(fullfile(features_folder, 'concavity descriptors', '*.mat')); %25

mkdir(output_folder);

%producing training data
test_size = 5;
training_size = size(kp_files,1) - test_size;

no_features = 350;

all_data = zeros(training_size + test_size, no_features);
all_label = zeros(training_size + test_size, 1);

counter = 1;

for i = 1:size(kp_files,1)
    load(fullfile(features_folder, 'fourier shape descriptors',fsd_files(i).name));
    load(fullfile(features_folder, 'Hu moments descriptor',hmd_files(i).name));
    load(fullfile(features_folder, 'Chain code',cc_files(i).name));
    load(fullfile(features_folder, 'keypoint descriptors',kp_files(i).name));
    load(fullfile(features_folder, 'concavity descriptors',concavity_files(i).name));
    
    all_data(i,:) = [fsd, M, cc_sampled', tr, conc];
    
    [path, feature_file, ext] = fileparts(fsd_files(i).name);
    feature_split = strsplit(feature_file, '_');
    feature_index = str2double(feature_split(1));
    for j = 1:length(labels)
        if feature_index == mapping(j)
            all_label(i) = labels(j);
        end
    end
end

% write the data into files
% fourier: 1-60; moments: 61-67; chain: 68-117; keypoints: 118-325;
% concavity: 326-350
all_data = all_data(:, 326:350);
libsvmwrite(strcat(output_folder, output_file), all_label, sparse(all_data));

