function segmentCurvatureLength_batch(folder)

mkdir(folder,'segment curvature length');
savepath = strcat(folder,'/segment curvature length/');

polys = dir(strcat(folder,'polygons\'));
segs = dir(strcat(folder,'segments\'));

curvature = [];
len = [];

for f = 1:size(polys,1)
        
    [pathstr,polyname,ext] = fileparts(polys(f).name);
    [pathstr,segmentname,ext] = fileparts(segs(f).name);
    
    % Load the polygon and segment instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(folder,'polygons\',polyname,ext);
        seg_source = strcat(folder,'segments\',segmentname,ext);
        
        feat_saveas = strcat(savepath,polyname,'_curv.mat');
        feat2_saveas = strcat(savepath,polyname,'_len.mat');
        
        load(source);
        load(seg_source);
        
        if exist('polygon','var')
            
            % Compute Features
            % -------------------------------------------------------------------------
            polygon = scalePolyConstrained(polygon);
            if ~isPolygonCCW(polygon)
                polygon=reversePolygon(polygon);
            end
            
            [curvature,len] = segmentCurvatureLength(polygon,segments,25,1);            
            % -------------------------------------------------------------------------
            
            save(feat_saveas,'curvature');
            save(feat2_saveas,'len');
        end
    end
    
end

end