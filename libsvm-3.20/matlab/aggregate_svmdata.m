function [] = aggregate_svmdata(labels_folder, features_folder, output_folder, labels_file, mapping_file, output_file)

% clear all
% close all

% loading lables, mapping, features
load(fullfile(labels_folder, labels_file));
load(fullfile(labels_folder, mapping_file));
fsd_files = dir(fullfile(features_folder, 'fourier shape descriptors', '*.mat')); %60
hmd_files = dir(fullfile(features_folder, 'Hu moments descriptor', '*.mat')); %7
cc_files = dir(fullfile(features_folder, 'Chain code', '*.mat')); %50
kp_files = dir(fullfile(features_folder, 'keypoint descriptors', '*.mat')); %208
concavity_files = dir(fullfile(features_folder, 'concavity descriptors', '*.mat')); %72
concavity_diff_files = dir(fullfile(features_folder, 'concavity distance descriptors', '*.mat')); %72
cchist_files = dir(fullfile(features_folder, 'chaincode histograms', '*.mat')); %128

mkdir(output_folder);

%producing training data
test_size = 5;
training_size = size(kp_files,1) - test_size;

no_features = 597;

all_data = zeros(training_size + test_size, no_features);
all_label = zeros(training_size + test_size, 1);

counter = 1;

for i = 1:size(kp_files,1)
    load(fullfile(features_folder, 'fourier shape descriptors',fsd_files(i).name));
    load(fullfile(features_folder, 'Hu moments descriptor',hmd_files(i).name));
    load(fullfile(features_folder, 'Chain code',cc_files(i).name));
    load(fullfile(features_folder, 'keypoint descriptors',kp_files(i).name));
    load(fullfile(features_folder, 'concavity descriptors',concavity_files(i).name));
    conc = ft_vector;
    load(fullfile(features_folder, 'concavity distance descriptors',concavity_diff_files(i).name)); %72
    load(fullfile(features_folder, 'chaincode histograms',cchist_files(i).name));
    
    all_data(i,:) = [fsd, M, cc_sampled', tr, conc, ft_vector, cc_hist];
    
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
% all_data_2 = all_data(:, 118:325);
libsvmwrite(strcat(output_folder, output_file), all_label, sparse(all_data));

end