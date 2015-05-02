function png2poly_batch(directory)

smooth_iter = 2;
max_points = 400;

%directory = './selected letters/synthetic s/';

letters = dir(directory);

for f = 1:length(letters)
    
    poly = {};
    [pathstr,name,ext] = fileparts(letters(f).name);
    
    % Load the letter instance
    if(strcmp(ext,'.png'))
        source = strcat(name,ext);
        polygon_saveas = strcat(directory,'polygons/',name,'.mat');
    
        % Extract Boundary
        poly = png2poly(source,smooth_iter,max_points);
        save(polygon_saveas,'poly');
    end
    
end
end