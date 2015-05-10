close all
clear all

% initialization
upper = 1;
lower = -1;

svmdata_dir = 'SVMData\';
svmtrain_file = 's_synthetic_svmdata_all.txt';
svmtrain_sel_file = 's_synthetic_svmdata.txt';
svmtest_file = 's_svmdata_all.txt';
sel_features_file = '..\..\data\synthetic s\selected_features.mat';

% get training and test data from files
[alltrain_label, alltrain_data] = libsvmread(strcat(svmdata_dir, svmtrain_file));
[alltest_label, alltest_data] = libsvmread(strcat(svmdata_dir, svmtest_file));

test_indices = [6, 12, 18, 24, 30, 36];

% use concavity + chain
% alltrain_data_sel = [alltrain_data(:,68:117), alltrain_data(:,326:397)];
% test_data = [alltest_data(test_indices, 68:117), alltest_data(test_indices, 326:397)];
alltrain_data_sel = alltrain_data;
test_data = alltest_data(test_indices, :);
test_label = alltest_label(test_indices);

% feature selection
libsvmwrite(strcat(svmdata_dir, svmtrain_sel_file), alltrain_label, sparse(alltrain_data_sel));
FeatureSelection;

% scaling features for both train and test data
[training_label, training_data, temp, tempt, max_features, min_features] ...
        = prepare_train_test(alltrain_data_sel, alltrain_label, []);
for i = 1:length(max_features)
    min_val = min_features(i);
    max_val = max_features(i);
    if max_val ~= min_val
        test_data(:,i) = lower + (upper - lower) .* ((test_data(:,i) - repmat(min_val,length(test_label),1))./(max_val - min_val));
    end
end
    
[svr_model, svr_model_sel] = learnlegibility(sel_features_file, training_label, training_data);

[predicted_label, accuracy, decision_values] = svmpredict(test_label, ...
        test_data, svr_model);
    
test_data_selected = test_data(:, sel_features);
[predicted_label_selected, accuracy_selected, decision_values_selected] = svmpredict(test_label, ...
        test_data_selected, svr_model_sel);
    
    