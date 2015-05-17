clear all
close all

% fileID = fopen('results_k_synthetic_segments.txt','w');

% initialization
output_folder = '..\..\SVMData\';
output_file = 's_expanded_svmdata_coarse_curvature.txt';

% read the svm data from the file
[all_label, all_data] = libsvmread(strcat(output_folder, output_file));
all_data = full(all_data);
all_data = [all_data(:,1:84)];

% get the training data, scale features
training_indices = [1:length(all_label)-5];
[training_data, training_label, max_features, min_features] ...
    = prepare_trainset(all_data, all_label, training_indices);

size_training = length(training_label);
max_acc = 0;
max_gamma = 1;

% grid search for parameter tuning
for i = -30:2:30
    gamma = 2^i;
    for j = 1:0.1:10
        nu = j / 10;
        param = ['-s 2 -t 2 -g ', num2str(gamma), ' -n ', num2str(nu), ' -v ', num2str(size_training), ' -q'];
        acc = svmtrain(training_label, training_data, param);
        if acc > max_acc
            max_acc = acc;
            max_gamma = gamma;
            max_nu = nu;
        end
    end
end

% try on new data
% testset_file = 'k_expanded_svmdata_testset.txt';
% [test_label, test_data] = libsvmread(strcat(output_folder, testset_file));
% test_data = full(test_data);
% test_label = [1; -1; 1; -1; 1];
% 
% param = ['-s 2 -t 2 -g ', num2str(max_gamma), ' -n ', num2str(max_nu), ' -q'];
% classifier = svmtrain(training_label, training_data, param);
% [predicted, accuracy, dv] = svmpredict(test_label, test_data, classifier);

