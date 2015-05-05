function extractTranslationBatch(directory)

mkdir(directory,'keypoint descriptors');
savepath = strcat(directory,'/keypoint descriptors/');

polys = dir(directory);

for f = 1:length(polys)
    
    tr = [];
    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Load the polygon instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(name,ext);
        feat_saveas = strcat(savepath,name,'_key.mat');
        
        load(source);
        
        % Scaling and centering procedure [ORIGINAL MESH]
        % -------------------------------------------------------------------------
        % Step 1: Constrain y-axis to [-1,1]
        % Step 2: Apply same scaling factor to x-axis, and recenter x axis at
        % midpoint
        miny = min(lettermesh.V(:,2));
        maxy = max(lettermesh.V(:,2));
        
        scalingfactor = (maxy-miny)/2;
        midpoint_y = (miny + scalingfactor);
        
        scaled_originalV(:,2) = (lettermesh.V(:,2)-midpoint_y)./scalingfactor;
        scaled_originalV(:,1) = (lettermesh.V(:,1)-midpoint_y)./scalingfactor;
        
        minx = min(lettermesh.V(:,1));
        maxx = max(lettermesh.V(:,1));
        midpoint_x = minx+((maxx-minx)/2);
        scaled_originalV(:,1) = lettermesh.V(:,1)-midpoint_x;
        % -------------------------------------------------------------------------
        
        % Scaling and centering procedure [DEFORMED MESH]
        % -------------------------------------------------------------------------
        % Step 1: Constrain y-axis to [-1,1]
        % Step 2: Apply same scaling factor to x-axis, and recenter x axis at
        % midpoint
        miny = min(smoothed_V2(:,2));
        maxy = max(smoothed_V2(:,2));
        
        scalingfactor = (maxy-miny)/2;
        midpoint_y = (miny + scalingfactor);
        
        scaled_deformedV(:,2) = (smoothed_V2(:,2)-midpoint_y)./scalingfactor;
        scaled_deformedV(:,1) = (smoothed_V2(:,1)-midpoint_y)./scalingfactor;
        
        minx = min(smoothed_V2(:,1));
        maxx = max(smoothed_V2(:,1));
        midpoint_x = minx+((maxx-minx)/2);
        scaled_deformedV(:,1) = smoothed_V2(:,1)-midpoint_x;
        % -------------------------------------------------------------------------
        
        %Sample
        %--------------------------------------------------------------------------
        Moving = [];
        Key_ix = [];
        
        for i = 1:length(lettermesh.bnd_V)
            if mod(i,3)==0
                Key_ix = [Key_ix; lettermesh.bnd_V(i)];
            end
        end
        
        Ref = scaled_originalV(Key_ix,:);
        Moving = scaled_deformedV(Key_ix,:);
        %--------------------------------------------------------------------------
        
        %Compute translation
        %--------------------------------------------------------------------------
        tr = Moving - Ref;
        %--------------------------------------------------------------------------
        dummy = [];
        for row = 1:size(tr,1)
            dummy = [dummy tr(row,:)];                
        end
        
        tr = dummy;
        
        save(feat_saveas,'tr');        
    end
end
end