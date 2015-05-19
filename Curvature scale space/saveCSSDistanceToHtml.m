function [] = saveCSSDistanceToHtml (folder, ref_file, html_file)

ks = dir(strcat(folder,'polygons\*.mat'));

load(strcat(folder,'polygons\', ref_file));
ref_contour = polygon;

CSS = [];
ixmap = {};

threshold = 40;
max_sigma = 70;
sigma_step = 10;

for f = 1:size(ks,1)
    
    [pathstr,kname,ext] = fileparts(ks(f).name);
    
    ksource = strcat(folder,'polygons\',kname,ext);
    load(ksource);
    
    contour = polygon;
    
    figure
    this_css = getCSSDistance(contour, ref_contour, threshold, max_sigma, sigma_step);
    CSS = [CSS, this_css];
    
    ixmap{f,1} = kname;
end

html_content = generateHtmlContentCSS(folder, ixmap, CSS);

fileID = fopen(html_file, 'w');
fprintf(fileID, '%s', html_content);
fclose(fileID);

end