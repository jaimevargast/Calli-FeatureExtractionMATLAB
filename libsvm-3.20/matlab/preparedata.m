clear all
close all

labels_folder = '..\..\labels';
features_folder = '..\..\letters and features\synthetic s';
labels_file = 's_synthetic.mat';
mapping_file = 'mapping_s_synthetic.mat';

% loading lables, mapping, features
load(fullfile(labels_folder, labels_file));
load(fullfile(labels_folder, mapping_file));
fsd_files = dir(fullfile(features_folder, 'fourier shape descriptors', '*.mat'));
hmd_files = dir(fullfile(features_folder, 'Hu moments descriptor', '*.mat'));
cc_files = dir(fullfile(features_folder, 'Chain code', '*.mat'));
concavity_files = dir(fullfile(features_folder, 'concavity descriptors', '*.mat'));

%producing training data
test_size = 6;
training_size = size(fsd_files,1) - test_size;
no_features = 142;
training_data = zeros(training_size,no_features);
training_label = zeros(training_size,1);
test_data = zeros(test_size,no_features);
test_label = zeros(test_size,1);
all_data = zeros(training_size + test_size, no_features);
all_label = zeros(training_size + test_size, 1);

counter = 1;

for i = 1:size(fsd_files,1)
    load(fullfile(features_folder, 'fourier shape descriptors',fsd_files(i).name));
    load(fullfile(features_folder, 'Hu moments descriptor',hmd_files(i).name));
    load(fullfile(features_folder, 'Chain code',cc_files(i).name));
    load(fullfile(features_folder, 'concavity descriptors',concavity_files(i).name));
    
    if mod(i,5) == 1
        test_data(counter, 1:60) = fsd;
        test_data(counter, 61:85) = conc;
        test_data(counter, 86:92) = M;
        test_data(counter, 93:142) = cc_sampled;
        all_data(i, :) = test_data(counter, :);
        hmd_files(i).name
    else
        training_data(i - counter + 1, 1:60) = fsd;
        training_data(i - counter + 1, 61:85) = conc;
        training_data(i - counter + 1, 86:92) = M;
        training_data(i - counter + 1, 93:142) = cc_sampled;
        all_data(i, :) = training_data(i - counter + 1, :);
    end
    
    [path, feature_file, ext] = fileparts(fsd_files(i).name);
    feature_split = strsplit(feature_file, '_');
    feature_index = str2double(feature_split(1));
    for j = 1:length(labels)
        if feature_index == mapping(j)
            if mod(i,5) == 1
                test_label(counter) = labels(j);
                counter = counter + 1;
            else
                training_label(i - counter + 1) = labels(j);
            end
            all_label(i) = labels(j);
        end
    end
end

%scaling features
lower = -1;
upper = +1;
max_features = max(training_data, [], 1);
min_features = min(training_data, [], 1);
for i = 1:no_features
    min = min_features(i);
    max = max_features(i);
    if max ~= min
        training_data(:,i) = lower + (upper - lower) .* ((training_data(:,i) - repmat(min,training_size,1))./(max - min));
        test_data(:,i) = lower + (upper - lower) .* ((test_data(:,i) - repmat(min,test_size,1))./(max - min));
%         all_data(:,i) = lower + (upper - lower) .* ((all_data(:,i) - repmat(min,test_size + training_size,1))./(max - min));
    end
end

% write the data into files
libsvmwrite('traindata.txt', training_label, sparse(training_data));
libsvmwrite('testdata.txt', test_label, sparse(test_data));
libsvmwrite('alldata.txt', all_label, sparse(all_data));

