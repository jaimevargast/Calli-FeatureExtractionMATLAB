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

% training_data = zeros(training_size,no_features);
% training_label = zeros(training_size,1);
% test_data = zeros(test_size,no_features);
% test_label = zeros(test_size,1);
all_data = zeros(training_size + test_size, no_features);
all_label = zeros(training_size + test_size, 1);

counter = 1;

for i = 1:size(kp_files,1)
    load(fullfile(features_folder, 'fourier shape descriptors',fsd_files(i).name));
    load(fullfile(features_folder, 'Hu moments descriptor',hmd_files(i).name));
    load(fullfile(features_folder, 'Chain code',cc_files(i).name));
    load(fullfile(features_folder, 'keypoint descriptors',kp_files(i).name));
    load(fullfile(features_folder, 'concavity descriptors',concavity_files(i).name));
    
    all_data(i,:) = [fsd, M, cc_sampled, tr, conc];
    
%     if mod(i,6) == 4
%         test_data(counter, 1:60) = fsd;
%         test_data(counter, 61:67) = M;
%         test_data(counter, 68:117) = cc_sampled;
%         test_data(counter, 118:325) = tr;
%         test_data(counter, 326:350) = conc;
%         all_data(i, :) = test_data(counter, :);
%         hmd_files(i).name
%     else
%         training_data(i - counter + 1, 1:60) = fsd;
%         training_data(i - counter + 1, 61:67) = M;
%         training_data(i - counter + 1, 68:117) = cc_sampled;
%         training_data(i - counter + 1, 118:325) = tr;
%         training_data(i - counter + 1, 326:350) = conc;
%         all_data(i, :) = training_data(i - counter + 1, :);
%     end
    
    [path, feature_file, ext] = fileparts(fsd_files(i).name);
    feature_split = strsplit(feature_file, '_');
    feature_index = str2double(feature_split(1));
    for j = 1:length(labels)
        if feature_index == mapping(j)
%             if mod(i,6) == 4
%                 test_label(counter) = labels(j);
%                 counter = counter + 1;
%             else
%                 training_label(i - counter + 1) = labels(j);
%             end
            all_label(i) = labels(j);
        end
    end
end

%scaling features
% lower = -1;
% upper = +1;
% max_features = max(training_data, [], 1);
% min_features = min(training_data, [], 1);
% for i = 1:no_features
%     min = min_features(i);
%     max = max_features(i);
%     if max ~= min
%         training_data(:,i) = lower + (upper - lower) .* ((training_data(:,i) - repmat(min,training_size,1))./(max - min));
%         test_data(:,i) = lower + (upper - lower) .* ((test_data(:,i) - repmat(min,test_size,1))./(max - min));
% %         all_data(:,i) = lower + (upper - lower) .* ((all_data(:,i) - repmat(min,test_size + training_size,1))./(max - min));
%     end
% end

% write the data into files
% fourier: 1-60; moments: 61-67; chain: 68-117; keypoints: 118-325;
% concavity: 326-350
% libsvmwrite('traindata.txt', training_label, sparse([training_data(:,1:60),training_data(:,68:117),training_data(:,118:350)]));
% libsvmwrite('testdata.txt', test_label, sparse([test_data(:,1:60),test_data(:,68:117),test_data(:,118:350)]));

libsvmwrite(strcat(output_folder, output_file), all_label, sparse(all_data));

