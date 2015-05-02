clear all
close all

[training_label, training_data] = libsvmread('traindata.txt');
[test_label, test_data] = libsvmread('testdata.txt');

min_err = flintmax;
min_gamma = 1;
min_cost = 1;

for i = -15:2:15
    gamma = 2^i;    
    for j = -15:2:15
        cost = 2^j;
        param = ['-s 3 -t 2 -g ', num2str(gamma), ' -c ', num2str(cost), ' -p 0.1 -v 26 -q'];
        svr_model = svmtrain(training_label, training_data, param);
        if svr_model < min_err
            min_err = svr_model;
            min_gamma = gamma;
            min_cost = cost;
        end
    end
end

param = ['-s 3 -t 2 -g ', num2str(min_gamma), ' -c ', num2str(min_cost), ' -p 0.1 -q'];
svr_model = svmtrain(training_label, training_data, param);
[predicted_label, accuracy, decision_values] = svmpredict(test_label, ...
    test_data, svr_model);