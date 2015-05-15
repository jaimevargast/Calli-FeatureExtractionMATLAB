clear all
close all

fileID = fopen('results_s_expanded_segments.txt','w');

% initialization
output_folder = '..\..\SVMData\';
output_file = 's_expanded_svmdata.txt';
% sel_features_file = '..\..\data\synthetic k\selected_features.mat';
% svmdata_file = 's_synthetic_svmdata.txt';

[all_label, all_data] = libsvmread(strcat(output_folder, output_file));
all_data = full(all_data);

% all_data(:,104) = zeros(size(all_data,1),1);

all_indices = [1:length(all_label)];
size_testset = 5;

all_combinations = combnk(all_indices, size_testset);
no_combinations = size(all_combinations,1);
combination_indices = randperm(no_combinations);
no_testsets = 5;
for i = 1:no_testsets
    testsets{i} = all_combinations(combination_indices(i),:);
end

% feature_sets = {'fourier', 'chain', 'keypoints', 'concavity', 'fourier+chain', 'fourier+keypoint', 'fourier+concavity', ...
%     'fourier+chain+concavity', 'all', 'chain+keypoint', 'chain+concavity', 'keypoint+concavity', 'chain+keypoint+concavity', ...
%     'concavitydistance', 'fourier+concavitydistance', 'chain+concavitydistance', 'keypoints+concavitydistance', ...
%     'chaincodehistogram', 'fourier+chaincodehist', 'keypoints+chaincodehist', 'concavity+chaincodehist', ...
%     'keypoints+concavity+chaincodehist', ...
%     'chaincodepolyline', 'fourier+chaincodepoly', 'keypoints+chaincodepoly', 'concavity+chaincodepoly', ...
%     'keypoints+concavity+chaincodepoly'};

feature_sets = {'length+curvature', 'all'};

selected_data{1} = all_data(:, 1:104);
selected_data{2} = all_data;

% fourier: 1-60; chain: 61-110; keypoints: 111-318;
% concavity: 319-390, concavity_diff: 391-462, chain histogram: 563-690,
% % polyline chaincode: 463-562
% selected_data{1} = all_data(:,1:60);
% selected_data{2} = all_data(:,61:110);
% selected_data{3} = all_data(:,111:318);
% selected_data{4} = all_data(:,319:390);
% selected_data{5} = [all_data(:,1:60), all_data(:,61:110)];
% selected_data{6} = [all_data(:,1:60), all_data(:,111:318)];
% selected_data{7} = [all_data(:,1:60), all_data(:,319:390)];
% selected_data{8} = [all_data(:,1:60), all_data(:,61:110), all_data(:,319:390)];
% selected_data{9} = all_data;
% selected_data{10} = [all_data(:,61:110), all_data(:,111:318)];
% selected_data{11} = [all_data(:,61:110), all_data(:,319:390)];
% selected_data{12} = all_data(:,111:390);
% selected_data{13} = all_data(:,61:390);
% % concavity distance
% selected_data{14} = all_data(:,391:462);
% selected_data{15} = [all_data(:,1:60), all_data(:,391:462)];
% selected_data{16} = [all_data(:,61:110), all_data(:,391:462)];
% selected_data{17} = [all_data(:,111:318), all_data(:,391:462)];
% % chaincode histogram
% selected_data{18} = all_data(:,563:690);
% selected_data{19} = [all_data(:,1:60), all_data(:,563:690)];
% selected_data{20} = [all_data(:,111:318), all_data(:,563:690)];
% selected_data{21} = [all_data(:,319:390), all_data(:,563:690)];
% selected_data{22} = [all_data(:,111:390), all_data(:,563:690)];
% % polyline chaincode
% selected_data{23} = all_data(:,463:562);
% selected_data{24} = [all_data(:,1:60), all_data(:,463:562)];
% selected_data{25} = [all_data(:,111:318), all_data(:,463:562)];
% selected_data{26} = [all_data(:,319:390), all_data(:,463:562)];
% selected_data{27} = [all_data(:,111:390), all_data(:,463:562)];

% for feature_index = 1:length(selected_data)
    
    sel_features = FeatureSelection(selected_data{1}, all_label);
    
    for index = 1:length(testsets)
        
        test_indices = testsets{index};
        train_indices = setdiff(all_indices, test_indices);
        
        [training_data, training_label, max_features, min_features] ...
            = prepare_trainset(selected_data{1}, all_label, train_indices);
        [test_data, test_label] = prepare_testset(selected_data{1}, all_label, ...
            test_indices, max_features, min_features);
        
        [svr_model, svr_model_sel] = learnlegibility(sel_features, training_label, training_data);
        
        [predicted_label, accuracy, decision_values] = svmpredict(test_label, ...
            test_data, svr_model);
        
        test_data_selected = test_data(:, sel_features);
        [predicted_label_selected, accuracy_selected, decision_values_selected] = svmpredict(test_label, ...
            test_data_selected, svr_model_sel);
        
        [test_label_sorted, I_test] = sort(test_label);
        [predicted_label_sorted, I_predicted] = sort(predicted_label);
        [predicted_label_sel_sorted, I_predicted_sel] = sort(predicted_label_selected);
        
        fprintf(fileID, 'Test set%d (ground truth), %f, %f, %f, %f, %f, %f, %d, %d, %d, %d, %d,\r\n', index, 0, test_label, I_test);
        fprintf(fileID, 'Test set%d (%s):, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d, %d,\r\n', index, feature_sets{2}, ...
            accuracy(2), predicted_label, I_predicted);
        fprintf(fileID, 'Test set%d (selected):, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d, %d,\r\n', ...
            index, accuracy_selected(2), predicted_label_selected, I_predicted_sel);
    end
    
% end


fclose(fileID);

