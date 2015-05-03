clear all
close all

[training_label, training_data] = libsvmread('traindata.txt');
[test_label, test_data] = libsvmread('testdata.txt');

param = ['-s 3 -t 2 -g ', num2str(0.5), ' -c ', num2str(0.5), ' -p 0.1 -q'];

% criterion
SVRwrapper = @(training_data, training_label, test_data, test_label)...
    sum((svmpredict(test_label, test_data, svmtrain(training_label, training_data, param)) - test_label).^2);

% feature selection
X = [training_data; test_data];
Y = [training_label; test_label];
[selected_features, his] = sequentialfs(SVRwrapper, X, Y);

save('..\..\letters and features\synthetic s\selected_features.mat', 'selected_features');