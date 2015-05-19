function [] = saveShapeContextToHtml(dir,html_file)

html_content = generateHTMLContentSC(dir);

fileID = fopen(html_file, 'w');
fprintf(fileID, '%s', html_content);
fclose(fileID);
 
end