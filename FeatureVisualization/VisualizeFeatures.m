clear all
close all

% get the data
svm_file = '..\SVMData\k_expanded_svmdata_classification.txt';
[all_label, all_data] = libsvmread(svm_file);
all_data = full(all_data);

% divide the data based on their class
legibile_indices = find(all_label == 1);
illegibile_indices = find(all_label == -1);

% MSD
dissimilarities = pdist(all_data);
[Y, stress] = mdscale(dissimilarities, 2, 'criterion', 'metricstress' );
% distances = pdist(Y);
plot(Y(legibile_indices,1), Y(legibile_indices,2), 'bo', ...
    Y(illegibile_indices,1), Y(illegibile_indices,2), 'ro');
legend('legibile', 'illegibile');