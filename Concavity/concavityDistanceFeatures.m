function concavityDistanceFeatures(directory)
    
load(strcat(directory,'/perfect.mat'));

mkdir(directory,'concavity distance descriptors');
savepath = strcat(directory,'/concavity distance descriptors/');

polys = dir(strcat(directory,'polygons\'));

for f = 1:length(polys)
    
    ft_vector = [];
    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Load the polygon instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(directory,'polygons\',name,ext);
        feat_saveas = strcat(savepath,name,'_conc.mat');
        
        
        load(source);
        
        if exist('polygon','var')
            
            % Compute Features
            % -------------------------------------------------------------------------
            P = [polygon(1).x polygon(1).y];
            P = scalePoly(P);            
            [chull,bays] = extractConcavities(P);
            ft_vector = bayFeatures(chull,bays,1);            
            ft_vector = ft_vector - perfect;
            % -------------------------------------------------------------------------
            
            save(feat_saveas,'ft_vector');
        end
    end
    
end

end