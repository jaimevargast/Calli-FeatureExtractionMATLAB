function [] = IntegrateFeatures(dir, curv_weights, len_weights, total_weights, html_file)

% This function is for integrating different feature distances into one value
% and put the results into an html file
% input:
%   - dir: directory for the letter
%   - curv_weights: weights for summing curvature of segments (1 x 4)
%   - len_weights: weights for summing length of segments (1 x 4)
%   - total_weights: weights for summing length and curvature (1 x 2)
%   - html_file: name of the html file to save the results

[hd, len_diff, ixmap] = SegmentCurvatureHausdorff(dir);

sum_len = len_diff * len_weights';
sum_curv = hd * curv_weights';

total_distance = total_weights(1) * sum_len + total_weights(2) * sum_curv;

html_content = generateHtmlContent(dir, ixmap, hd, len_diff, total_distance);

fileID = fopen(html_file, 'w');
fprintf(fileID, '%s', html_content);
fclose(fileID);

end

