images_dir = '..\data\s expanded';
% pairwise_results_file = 'pairs_result_zeinab.mat';
comparisons_file = 'pairs_comparison_s_expanded.mat';
scores_file = 'scores_s_expanded.mat';
scores_file_txt = 'scores_s_expanded.txt';

% get the comparison tables from user opinion
% process_pairs_results(pairwise_results_file, comparisons_file, 0);

% get the scores from bradley terry model
ranking_synthetic(comparisons_file, scores_file);

% now map the scores to the file names and write to the text file
image_files = dir(fullfile(images_dir, '*.png'));
indices = [1:length(image_files)];
filenames = [];
for i = 1:length(indices)
    [path, name, ext] = fileparts(image_files(i).name);
    filenames = [filenames, str2num(name)];
end
load(scores_file);

fileID = fopen(scores_file_txt, 'w');
for i = 1:length(scores)
    fprintf(fileID, '%d %d %f\r\n', indices(i), filenames(i), scores(i));
end
fclose(fileID);