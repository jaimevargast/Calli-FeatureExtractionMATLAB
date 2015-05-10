function [sel_features] = FeatureSelection(all_data, all_label)

param = ['-s 3 -t 2 -g ', num2str(0.5), ' -c ', num2str(0.5), ' -p 0.1 -q'];

% criterion
SVRwrapper = @(training_x, training_y, test_x, test_y)...
    sum((svmpredict(test_y, test_x, svmtrain(training_y, training_x, param)) - test_y).^2);

% feature selection
% remember that for feature selection, you need to do leave-one-out,
% otherwise, everytime you run, you get different features selected
X = all_data;
Y = all_label;
[selected_features, his] = sequentialfs(SVRwrapper, X, Y, 'cv', 30);
sel_features = find(selected_features);

end

