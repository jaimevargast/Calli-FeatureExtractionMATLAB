function [] = saveFullShapeContextToHtml(dir,html_file)

html_content = generateHTMLContentFullSC(dir);

fileID = fopen(html_file, 'w');
fprintf(fileID, '%s', html_content);
fclose(fileID);
 
end