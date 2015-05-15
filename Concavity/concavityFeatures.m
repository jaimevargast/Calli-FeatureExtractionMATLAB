function concavityFeatures(directory)
    

mkdir(directory,'concavity descriptors test');
savepath = strcat(directory,'\concavity descriptors test\');

polys = dir(strcat(directory,'\polygons\'));

for f = 1:length(polys)
    
    conc = [];
    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Load the polygon instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(directory,'\polygons\',name,ext);
        feat_saveas = strcat(savepath,name,'_conc.mat');
        
        
        load(source);
        
        if exist('polygon','var')
            
            % Compute Features
            % -------------------------------------------------------------------------
%             P = [polygon(1).x polygon(1).y];
            P = polygon;
            P = scalePoly(P);            
            [chull,bays] = extractConcavities(P);
            ft_vector = bayFeatures(chull,bays,1,1);
            % -------------------------------------------------------------------------
            
            save(feat_saveas,'ft_vector');
        end
    end
    
end

end