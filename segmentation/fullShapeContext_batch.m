function fullShapeContext_batch(folder)

mkdir(folder,'full shape context');
savepath = strcat(folder,'full shape context\');

polys = dir(strcat(folder,'polygons\*.mat'));

context = [];

for f = 1:size(polys,1)
        
    [pathstr,polyname,ext] = fileparts(polys(f).name);

    
    % Load the polygon and segment instance
    if(strcmp(ext,'.mat'))

        
        source = strcat(folder,'polygons\',polyname,ext);
        
        feat_saveas = strcat(savepath,polyname,'_sc.mat');        
        
        load(source);
        
        if exist('polygon','var')
            
            % Compute Features
            % -------------------------------------------------------------------------
          
            context = fullShapeContext(polygon);
            % -------------------------------------------------------------------------
            
            save(feat_saveas,'context');
            
        end
    end
    
end

end