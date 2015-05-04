function concavityFeatures(directory)
    

mkdir(directory,'concavity descriptors');
savepath = strcat(directory,'/concavity descriptors/');

polys = dir(directory);

for f = 1:length(polys)
    
    conc = [];
    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Load the polygon instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(name,ext);
        feat_saveas = strcat(savepath,name,'_conc.mat');
        
        
        load(source);
        
        if exist('polygon','var')
            
            V = [polygon(1).x polygon(1).y];
            
            % Scaling and centering procedure:
            % -------------------------------------------------------------------------
            % Step 1: Constrain y-axis to [-1,1]
            % Step 2: Apply same scaling factor to x-axis, and recenter x axis at
            % midpoint
            miny = min(V(:,2));
            maxy = max(V(:,2));
            
            scalingfactor = (maxy-miny)/2;
            midpoint_y = (miny + scalingfactor);
            
            V(:,2) = (V(:,2)-midpoint_y)./scalingfactor;
            V(:,1) = (V(:,1)-midpoint_y)./scalingfactor;
            
            minx = min(V(:,1));
            maxx = max(V(:,1));
            midpoint_x = minx+((maxx-minx)/2);
            V(:,1) = V(:,1)-midpoint_x;
            % -------------------------------------------------------------------------
            
            
            % Compute Features
            % -------------------------------------------------------------------------
            [chull,bays] = extractConcavities(V);
            [Area,Centroid,W,H] = bayFeatures(chull,bays);
            % -------------------------------------------------------------------------
            
            conc = [];
            
            for row = 1:size(Area,1)
                conc = [conc Centroid(row,:) Area(row) W(row) H(row)];
            end
            save(feat_saveas,'conc');
        end
    end
    
end

end