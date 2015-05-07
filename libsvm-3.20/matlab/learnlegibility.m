% clear all
% close all

load('..\..\letters and features\synthetic s\selected_features.mat');
svmdata_dir = 'SVMData\';
svmdata_file = 's_synthetic_svmdata.txt';
test_indices = [6, 12, 18, 24, 30];

[training_label, training_data, test_label, test_data, max_features, min_features] ...
    = prepare_train_test(svmdata_file, svmdata_dir, test_indices);

sel_features = find(selected_features);
training_data_selected = training_data(:, sel_features);
test_data_selected = test_data(:, sel_features);

min_err = flintmax;
min_gamma = 1;
min_cost = 1;

size_training = length(training_label);

for i = -15:2:15
    gamma = 2^i;    
    for j = -15:2:15
        cost = 2^j;
        param = ['-s 3 -t 2 -g ', num2str(gamma), ' -c ', num2str(cost), ' -p 0.1 -v 25 -q'];
        err = svmtrain(training_label, training_data, param);
        if err < min_err
            min_err = err;
            min_gamma = gamma;
            min_cost = cost;
        end
    end
end

param = ['-s 3 -t 2 -g ', num2str(min_gamma), ' -c ', num2str(min_cost), ' -p 0.1 -q'];
svr_model = svmtrain(training_label, training_data, param);
[predicted_label, accuracy, decision_values] = svmpredict(test_label, ...
    test_data, svr_model);


% regression with selected features
min_err = flintmax;
min_gamma = 1;
min_cost = 1;

for i = -15:2:15
    gamma = 2^i;    
    for j = -15:2:15
        cost = 2^j;
        param = ['-s 3 -t 2 -g ', num2str(gamma), ' -c ', num2str(cost), ' -p 0.1 -v 25 -q'];
        err = svmtrain(training_label, training_data_selected, param);
        if err < min_err
            min_err = err;
            min_gamma = gamma;
            min_cost = cost;
        end
    end
end

param = ['-s 3 -t 2 -g ', num2str(min_gamma), ' -c ', num2str(min_cost), ' -p 0.1 -q'];
svr_model = svmtrain(training_label, training_data_selected, param);
[predicted_label_selected, accuracy_selected, decision_values_selected] = svmpredict(test_label, ...
    test_data_selected, svr_model);
