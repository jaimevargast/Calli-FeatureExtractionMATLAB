close all
clear all

% svm data file
svmdata_dir = '..\..\SVMData';
svmdata_file = 's_expanded_svmdata_classification.txt';

% get the data and labels
[all_label, all_data] = libsvmread(fullfile(svmdata_dir, svmdata_file));

% length: 1-4, curvature: 5-104, concavity: 105-176,
% chain hist: 177-304, fsd: 305-364
% all_data = all_data(:,12373:12484);
all_data = [all_data(:,25:84),all_data(:,12373:12484)];

% prepare train and test data
train_indices = [1:length(all_label)-5];
[ train_data, train_label, max_features, min_features ] ...
    = prepare_trainset(all_data, all_label, train_indices);

% train the model, leave-one-out, get the best accuracy
size_training = length(train_label);
max_acc = 0;
max_gamma = 1;

% grid search for parameter tuning
% for i = -30:2:30
%     gamma = 2^i;
for j = -30:2:30
    cost = 2^j;
    param = ['-s 5 -c ', num2str(cost), ' -q -v ', num2str(size_training)];
    acc = train(train_label, train_data, param);
    if acc > max_acc
        max_acc = acc;
        max_cost = cost;
    end
end
% end

% try on new data
param = ['-s 5 -c ', num2str(max_cost), '-b 1 -q'];
model = train(train_label, train_data, param);
[ test_data, test_label ] = prepare_testset(all_data, all_label, [61:65], max_features, min_features);
[predicted_label, acc, dv] = predict(test_label, test_data, model);



