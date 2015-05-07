clear all
close all

fileID = fopen('results_s_synthetic_featuresets.txt','w');

preparedata;

feature_sets = {'fourier', 'chain', 'keypoints', 'concavity', 'fourier+chain', 'fourier+keypoint', 'fourier+concavity', ...
    'fourier+chain+concavity', 'all', 'chain+keypoint', 'chain+concavity', 'keypoint+concavity', 'chain+keypoint+concavity'};

% fourier: 1-60; moments: 61-67; chain: 68-117; keypoints: 118-325;
% concavity: 326-397
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


for index = 1:length(feature_sets)
    
    %selected_data = all_data(:,1:60);
    libsvmwrite(strcat(output_folder, output_file), all_label, sparse(selected_data{index}));
    FeatureSelection;
    learnlegibility;
    [predicted_label_sorted, I_predicted] = sort(predicted_label);
    [predicted_label_sel_sorted, I_predicted_sel] = sort(predicted_label_selected);
    fprintf(fileID, '%s %f %f %f %f %f %f %d %d %d %d %d\r\n', feature_sets{index}, accuracy(2), predicted_label, I_predicted);
    fprintf(fileID, '%s %f %f %f %f %f %f %d %d %d %d %d\r\n', ...
        strcat(feature_sets{index},'(selected)'), accuracy_selected(2), predicted_label_selected, I_predicted_sel);
end


fclose(fileID);