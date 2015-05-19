function segmentShapeContext_batch(folder)

mkdir(folder,'shape context per segment');
savepath = strcat(folder,'shape context per segment\');

polys = dir(strcat(folder,'polygons\*.mat'));
segs = dir(strcat(folder,'segments\*.mat'));

context = {};

for f = 1:size(polys,1)
        
    [pathstr,polyname,ext] = fileparts(polys(f).name);
%    [pathstr,segmentname,ext] = fileparts(segs(f).name);
    
    % Load the polygon and segment instance
    if(strcmp(ext,'.mat'))
%     if(strcmp(ext,'.mat') && ~isempty(strfind(polyname, 'test')))
        
        source = strcat(folder,'polygons\',polyname,ext);
        seg_source = strcat(folder,'segments\',polyname,'_seg',ext);
        
        feat_saveas = strcat(savepath,polyname,'_sc.mat');        
        
        load(source);
        load(seg_source);       
        
        if exist('polygon','var')
            
            % Compute Features
            % -------------------------------------------------------------------------
            polygon = scalePolyConstrained(polygon);
            if isPolygonCCW(polygon)
                polygon=reversePolygon(polygon);
            end
            
            [aligned_segments,context] = segmentShapeContext(polygon,segments,0);            
            % -------------------------------------------------------------------------
            grid_size = ceil(sqrt(size(polys,1)));
            
            cmap = ['r'; 'y'; 'b'; 'g'; 'm'; 'k'; 'r'; 'y'];            
            for i = 1:numel(aligned_segments)
                figure(i);
                subplot(grid_size,grid_size,f)
                drawPolyline(aligned_segments{i},'Color',cmap(i,:),'LineWidth',2,'Marker','*');
                axis equal;
            end
                                    
            save(feat_saveas,'context');
            
        end
    end
    
end
end