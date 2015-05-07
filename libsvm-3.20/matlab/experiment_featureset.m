clear all
close all

fileID = fopen('results_s_synthetic_featuresets.txt','w');

% prepare data
labels_folder = '..\..\labels';
features_folder = '..\..\data\synthetic s';
output_folder = 'SVMData\';
labels_file = 's_synthetic.mat';
mapping_file = 'mapping_s_synthetic.mat';
output_file = 's_synthetic_svmdata_all.txt';

% learn legibility
sel_features_file = '..\..\data\synthetic s\selected_features.mat';
svmdata_file = 's_synthetic_svmdata.txt';
test_indices = [1, 7, 13, 19, 25];

preparedata(labels_folder, features_folder, output_folder, labels_file, mapping_file, output_file);
[all_label, all_data] = libsvmread(strcat(output_folder, output_file));

[training_label, training_data, test_label, test_data, max_features, min_features] ...
    = prepare_train_test(all_data, all_label, test_indices);

feature_sets = {'fourier', 'chain', 'keypoints', 'concavity', 'fourier+chain', 'fourier+keypoint', 'fourier+concavity', ...
    'fourier+chain+concavity', 'all', 'chain+keypoint', 'chain+concavity', 'keypoint+concavity', 'chain+keypoint+concavity', ...
    'concavitydistance', 'fourier+concavitydistance', 'chain+concavitydistance', 'keypoints+concavitydistance'};

% fourier: 1-60; moments: 61-67; chain: 68-117; keypoints: 118-325;
% concavity: 326-397, concavity_diff: 398-469
selected_data{1} = all_data(:,1:60);
selected_data{2} = all_data(:,68:117);
selected_data{3} = all_data(:,118:325);
selected_data{4} = all_data(:,326:397);
selected_data{5} = [all_data(:,1:60), all_data(:,68:117)];
selected_data{6} = [all_data(:,1:60), all_data(:,118:325)];
selected_data{7} = [all_data(:,1:60), all_data(:,326:397)];
selected_data{8} = [all_data(:,1:60), all_data(:,68:117), all_data(:,326:397)];
selected_data{9} = all_data;
selected_data{10} = [all_data(:,68:117), all_data(:,118:325)];
selected_data{11} = [all_data(:,68:117), all_data(:,326:397)];
selected_data{12} = all_data(:,118:397);
selected_data{13} = all_data(:,68:397);
selected_data{14} = all_data(:,398:469);
selected_data{15} = [all_data(:,1:60), all_data(:,398:469)];
selected_data{16} = [all_data(:,68:117), all_data(:,398:469)];
selected_data{17} = [all_data(:,118:325), all_data(:,398:469)];


for index = 14:length(feature_sets)
    
    %selected_data = all_data(:,1:60);
    libsvmwrite(strcat(output_folder, svmdata_file), all_label, sparse(selected_data{index}));
    FeatureSelection;
    
    [training_label, training_data, test_label, test_data, max_features, min_features] ...
        = prepare_train_test(selected_data{index}, all_label, test_indices);
    
    [svr_model, svr_model_sel] = learnlegibility(sel_features_file, training_label, training_data);
    
    [predicted_label, accuracy, decision_values] = svmpredict(test_label, ...
        test_data, svr_model);
    
    test_data_selected = test_data(:, sel_features);
    [predicted_label_selected, accuracy_selected, decision_values_selected] = svmpredict(test_label, ...
        test_data_selected, svr_model_sel);
    
    [predicted_label_sorted, I_predicted] = sort(predicted_label);
    [predicted_label_sel_sorted, I_predicted_sel] = sort(predicted_label_selected);
    
    fprintf(fileID, '%s %f %f %f %f %f %f %d %d %d %d %d\r\n', feature_sets{index}, accuracy(2), predicted_label, I_predicted);
    fprintf(fileID, '%s %f %f %f %f %f %f %d %d %d %d %d\r\n', ...
        strcat(feature_sets{index},'(selected)'), accuracy_selected(2), predicted_label_selected, I_predicted_sel);
end


fclose(fileID);

