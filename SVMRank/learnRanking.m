close all
clear all

svmdata_dir = '..\SVMData';
svmdata_file = 'k_synthetic_svmdata.txt';

% reading features and labels from file
[all_label, all_data] = libsvmread(fullfile(svmdata_dir, svmdata_file));
all_data = full(all_data);

% specify which instances to use as test and remaining as training
test_indices = [1, 15, 19, 35, 37];
all_indices = [1:length(all_label)];
train_indices = setdiff(all_indices, test_indices);

% dividing the data into training and test sets
[training_data, training_label, max_features, min_features] ...
    = prepare_trainset(all_data, all_label, train_indices);
[test_data, test_label] = prepare_testset(all_data, all_label, ...
    test_indices, max_features, min_features);

% preparing data for svmrank
A = generateConstraints(training_label);

% parameter tuning by grid search
w = zeros(11, size(all_data,2))';
predicted_scores_all = zeros(length(test_label), 11);
min_err = flintmax;
min_i = 1;

for i = 1:11
    C = 2^(i-6)*ones(size(A,1),1);
    w(:,i) = ranksvm(training_data, A, C);
    predicted_scores_all(:,i) = test_data * w(:,i);
    err = sum((predicted_scores_all(:,i) - test_label).^2);
    err = err / length(test_label);
    if err < min_err
        min_err = err;
        min_i = i;
    end
end

% train the model
% w = ranksvm(training_data, A, 10^(min_i-6)*ones(size(A,1),1));

% test the model
predicted_scores = test_data * w(:, min_i);

