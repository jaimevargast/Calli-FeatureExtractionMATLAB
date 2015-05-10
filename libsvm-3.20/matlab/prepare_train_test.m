function [training_label, training_data, test_label, ...
    test_data, max_features, min_features] = prepare_train_test(all_data, all_label, test_indices)

% [all_label, all_data] = libsvmread(strcat(svmdata_dir, svmdata_file));

no_features = size(all_data, 2);
data_size = size(all_data, 1);
test_size = length(test_indices);
training_size = data_size - test_size;

training_indices = zeros(1, training_size);
counter = 1;
for i = 1:data_size
    if find(test_indices == i)
    else
        training_indices(counter) = i;
        counter = counter + 1;
    end
end

training_label = all_label(training_indices);
training_data = all_data(training_indices, :);
test_label = all_label(test_indices);
test_data = all_data(test_indices, :);

%scaling features
lower = -1;
upper = +1;
max_features = max(training_data, [], 1);
min_features = min(training_data, [], 1);
for i = 1:no_features
    min_val = min_features(i);
    max_val = max_features(i);
    if max_val ~= min_val
        training_data(:,i) = lower + (upper - lower) .* ((training_data(:,i) - repmat(min_val,training_size,1))./(max_val - min_val));
        test_data(:,i) = lower + (upper - lower) .* ((test_data(:,i) - repmat(min_val,test_size,1))./(max_val - min_val));
    end
end

end