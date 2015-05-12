clear all
close all

% fileID = fopen('results_k_synthetic_segments.txt','w');

% initialization
output_folder = '..\..\SVMData\';
output_file = 'k_experiment_svmdata.txt';

% read the svm data from the file
[all_label, all_data] = libsvmread(strcat(output_folder, output_file));
all_data = full(all_data);

% get the training data, scale features
[training_data, training_label, max_features, min_features] ...
    = prepare_trainset(all_data, all_label, [1:10]);

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

max_acc
max_gamma
max_nu