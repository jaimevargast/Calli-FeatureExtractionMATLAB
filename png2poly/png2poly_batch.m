function png2poly_batch(directory)
% png2poly_batch - Extracts boundaries of letter forms from PNG files as a
% polygon

mkdir(directory,'polygons');
smooth_iter = 2;
max_points = 400;

%directory = './selected letters/synthetic s/';

letters = dir(directory);

for f = 1:length(letters)
    
    polygon = {};
    [pathstr,name,ext] = fileparts(letters(f).name);
    
    % Load the letter instance
    if(strcmp(ext,'.png'))
        source = strcat(directory,name,ext);
        polygon_saveas = strcat(directory,'polygons/',name,'.mat');
    
        % Extract Boundary
        polygon = png2poly(source,smooth_iter,max_points);
        save(polygon_saveas,'polygon');
    end
    
end
end