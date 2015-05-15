clear all
close all

% get the data
svm_file = '..\SVMData\k_expanded_svmdata_oldfeatures.txt';
[all_label, all_data] = libsvmread(svm_file);
all_data = full(all_data);

% divide the data based on their class
legibile_indices = find(all_label == 1);
illegibile_indices = find(all_label == -1);

% different sets/combination of features
% length: 1-4, curvature: 5-104, concavity: 105-176,
% chain hist: 177-304, fsd: 305-364
feature_sets = {'segment curvature', 'concavity', 'chain code histogram',...
    'fourier shape descriptor', 'segment length_curvature', 'segment length_curvature_concavity', ...
    'segment length_curvature_chain code histogram', 'segment length_curvature_fourier descriptor', ...
    'concavity_chain code histogram', 'all'};

data_subset{1} = all_data(:, 1:4);
data_subset{2} = all_data(:, 5:104);
data_subset{3} = all_data(:, 105:176);
data_subset{4} = all_data(:, 177:304);
data_subset{5} = all_data(:, 305:364);
data_subset{6} = all_data(:, 1:104);
data_subset{7} = all_data(:, 1:176);
data_subset{8} = [all_data(:, 1:104), all_data(:,177:304)];
data_subset{9} = [all_data(:, 1:104), all_data(:,305:364)];
data_subset{10} = all_data(:, 105:304);
data_subset{11} = all_data(:, 1:364);

results_dir = '..\data\k expanded\feature visualization\';
mkdir(results_dir);
% MSD
for i = 1:length(feature_sets)
    figure
    dissimilarities = pdist(data_subset{i+1});
    [Y, stress] = mdscale(dissimilarities, 2, 'criterion', 'metricstress', 'start', 'random');
    % distances = pdist(Y);
    plot(Y(legibile_indices,1), Y(legibile_indices,2), 'bo', ...
        Y(illegibile_indices,1), Y(illegibile_indices,2), 'ro');
    legend('legibile', 'illegibile');
    title(feature_sets{i});
    
    saveas(gcf, strcat(results_dir, feature_sets{i},'.jpg'));
    
end