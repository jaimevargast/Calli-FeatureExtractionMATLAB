function segmentProfile_batch(folder)

mkdir(folder,'segment profiles');
savepath = strcat(folder,'/segment profiles/');

polys = dir(strcat(folder,'polygons\'));
segs = dir(strcat(folder,'segments\'));

profile = [];

for f = 1:length(polys)
        
    [pathstr,polyname,ext] = fileparts(polys(f).name);
    [pathstr,segmentname,ext] = fileparts(segs(f).name);
    
    % Load the polygon and segment instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(folder,'polygons\',polyname,ext);
        seg_source = strcat(folder,'segments\',segmentname,ext);
        
        feat_saveas = strcat(savepath,polyname,'_prof.mat');        
        
        load(source);
        load(seg_source);
        
        if exist('polygon','var')
            
            % Compute Features
            % -------------------------------------------------------------------------
            polygon = scalePolyConstrained(polygon);
            if ~isPolygonCCW(polygon)
                polygon=reversePolygon(polygon);
            end
            
            profile = segmentProfile(polygon,segments,25,0);            
            % -------------------------------------------------------------------------
            
            save(feat_saveas,'profile');
        end
    end
    
end

end