function [ test_data, test_label ] = ...
    prepare_testset( all_data, all_label, test_indices, max_features, min_features )
%PREPARE_TESTSET Summary of this function goes here
%   Detailed explanation goes here

no_features = size(all_data, 2);
% data_size = size(all_data, 1);
test_size = length(test_indices);

test_label = all_label(test_indices);
test_data = all_data(test_indices, :);

%scaling features
lower = -1;
upper = +1;
for i = 1:no_features
    min_val = min_features(i);
    max_val = max_features(i);
    if max_val ~= min_val
%         test_data(:,i) = lower + (upper - lower) .* ((test_data(:,i) - repmat(min_val,test_size,1))./(max_val - min_val));
    end
end

end

