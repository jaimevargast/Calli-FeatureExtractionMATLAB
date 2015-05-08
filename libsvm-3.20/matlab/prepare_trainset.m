function [ train_data, train_label, max_features, min_features ] ...
    = prepare_trainset( all_data, all_label, train_indices )
%PREPARE_TRAINSET Summary of this function goes here
%   Detailed explanation goes here

no_features = size(all_data, 2);
% data_size = size(all_data, 1);
train_size = length(train_indices);

train_label = all_label(train_indices);
train_data = all_data(train_indices, :);

%scaling features
lower = -1;
upper = +1;
max_features = max(train_data, [], 1);
min_features = min(train_data, [], 1);
for i = 1:no_features
    min_val = min_features(i);
    max_val = max_features(i);
    if max_val ~= min_val
%         train_data(:,i) = lower + (upper - lower) .* ((train_data(:,i) - repmat(min_val,train_size,1))./(max_val - min_val));
    end
end

end

