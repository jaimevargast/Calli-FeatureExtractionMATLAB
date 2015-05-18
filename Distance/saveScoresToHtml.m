function [] = saveScoresToHtml(dir, scores_file, mapping_file, html_file )

scores_dir = '.\labels\';
load(strcat(scores_dir, scores_file));
load(strcat(scores_dir, mapping_file));

html_content = generateHtmlContentScores(dir, labels, mapping);

fileID = fopen(html_file, 'w');
fprintf(fileID, '%s', html_content);
fclose(fileID);
 
end