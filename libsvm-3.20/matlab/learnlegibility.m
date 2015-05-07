function [svr_model, svr_model_sel] = ...
    learnlegibility(sel_features_file, training_label, training_data)

% clear all
% close all

load(sel_features_file);

% [training_label, training_data, test_label, test_data, max_features, min_features] ...
%     = prepare_train_test(svmdata_file, svmdata_dir, test_indices);

sel_features = find(selected_features);
training_data_selected = training_data(:, sel_features);

min_err = flintmax;
min_gamma = 1;
min_cost = 1;

size_training = length(training_label);

for i = -15:2:15
    gamma = 2^i;    
    for j = -15:2:15
        cost = 2^j;
        param = ['-s 3 -t 2 -g ', num2str(gamma), ' -c ', num2str(cost), ' -p 0.1 -v ', num2str(size_training), ' -q'];
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


% regression with selected features
min_err = flintmax;
min_gamma = 1;
min_cost = 1;

for i = -15:2:15
    gamma = 2^i;    
    for j = -15:2:15
        cost = 2^j;
        param = ['-s 3 -t 2 -g ', num2str(gamma), ' -c ', num2str(cost), ' -p 0.1 -v ', num2str(size_training), ' -q'];
        err = svmtrain(training_label, training_data_selected, param);
        if err < min_err
            min_err = err;
            min_gamma = gamma;
            min_cost = cost;
        end
    end
end

param = ['-s 3 -t 2 -g ', num2str(min_gamma), ' -c ', num2str(min_cost), ' -p 0.1 -q'];
svr_model_sel = svmtrain(training_label, training_data_selected, param);

end