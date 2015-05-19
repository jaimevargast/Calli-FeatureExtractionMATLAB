function [sel_features] = FeatureSelection(all_data, all_label)

% param = ['-s 3 -t 2 -g ', num2str(0.03), ' -c ', num2str(0.1), ' -p 0.1 -q'];

% criterion
% SVRwrapper = @(training_x, training_y, test_x, test_y)...
%     sum((svmpredict(test_y, test_x, svmtrain(training_y, training_x, param)) - test_y).^2);

% feature selection
% remember that for feature selection, you need to do leave-one-out,
% otherwise, everytime you run, you get different features selected
X = all_data;
Y = all_label;
[selected_features, his] = sequentialfs(@svrwrapper, X, Y, 'cv', length(all_label));
sel_features = find(selected_features);

end

function min_err = svrwrapper(training_x, training_y, test_x, test_y)

min_err = flintmax;
% min_gamma = 1;
% min_cost = 1;

for i = -3:2:3
    gamma = 2^i;
    for j = -3:2:3
        cost = 2^j;
        param = ['-s 3 -t 2 -g ', num2str(gamma), ' -c ', num2str(cost), ' -p 0.1 -q'];
        model = svmtrain(training_y, training_x, param);
        [predicted_y, accuracy, decision_values] = svmpredict(test_y, test_x, model);
        err = sum((predicted_y - test_y).^2);
        err = err / length(test_y);
        if err < min_err
            min_err = err;
            %             min_gamma = gamma;
            %             min_cost = cost;
        end
    end
end

end

