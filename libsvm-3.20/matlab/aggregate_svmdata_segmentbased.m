function [] = aggregate_svmdata_segmentbased(letter, labels_file, mapping_file, output_file)

% clear all
% close all


labels_folder = '..\..\labels\';
features_folder = strcat('..\..\data\', letter);
output_folder = '..\..\SVMData\';

% loading lables, mapping, features
% load(fullfile(labels_folder, labels_file));
% load(fullfile(labels_folder, mapping_file));
curvature_files = dir(fullfile(features_folder, 'segment curvature length', '*_curv.mat')); %100
length_files = dir(fullfile(features_folder, 'segment curvature length', '*_len.mat')); %4
% concavity_files = dir(fullfile(features_folder, 'concavity descriptors', '*_conc.mat')); %72

mkdir(output_folder);

%producing training data
test_size = 5;
training_size = size(curvature_files,1) - test_size;

no_features = 104;

% all_data = zeros(training_size + test_size, no_features);
% all_label = zeros(training_size + test_size, 1);
all_data = zeros(test_size, no_features);
all_label = zeros(test_size, 1);

counter = 1;

for i = 1:size(curvature_files,1)
    
    [path, feature_file, ext] = fileparts(curvature_files(i).name);
    
    if (~isempty(strfind(feature_file, 'test')))
        
        load(fullfile(features_folder, 'segment curvature length',curvature_files(i).name));
        load(fullfile(features_folder, 'segment curvature length',length_files(i).name));
        %     load(fullfile(features_folder, 'concavity descriptors',concavity_files(i).name));
        %     len = length;
        curvature = curvature;
        
        all_data(counter,:) = [len, curvature];
        %     all_data(i,:) = [len, curvature, ft_vector];
        counter = counter + 1;
        
        feature_file
        feature_split = strsplit(feature_file, '_');
        feature_index = str2double(feature_split(1));
        %     for j = 1:length(labels)
        %         if feature_index == mapping(j)
        %             all_label(i) = labels(j);
        %         end
        %     end
        %     if feature_index < 21
        %         all_label(i) = 1;
        %     else
        %         all_label(i) = -1;
        %     end
    end
end

% write the data into files
% fourier: 1-60; moments: 61-67; chain: 68-117; keypoints: 118-325;
% concavity: 326-350
% all_data_2 = all_data(:, 118:325);
libsvmwrite(strcat(output_folder, output_file), all_label, sparse(all_data));

end