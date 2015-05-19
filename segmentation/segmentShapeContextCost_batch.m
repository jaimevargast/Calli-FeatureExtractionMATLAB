function segmentShapeContextCost_batch(folder)

%mkdir(folder,'shape context per segment');
savepath = strcat(folder,'shape context per segment\');

hists = dir(strcat(folder,'shape context per segment\*_sc.mat'));

%reference
load(strcat(folder,'shape context per segment\1_sc.mat'));
load(strcat(folder,'polygons\1.mat'));
load(strcat(folder,'segments\1_seg.mat'));
ref = context;
ref_poly = polygon;
ref_seg = segments;

P1 = polygon(1,:);
ref_angles = zeros(1,numel(segments));
for i = 1:numel(segments)
    ix = segments{i};
    P2 = polygon(ix(1),:);
    ref_angles(i) = angle2Points(P1,P2);
end
    
    

cost = [];

for f = 1:size(hists,1)
        
    [pathstr,histname,ext] = fileparts(hists(f).name);
    
    %Load the histogram
    if(strcmp(ext,'.mat'))
       
        source = strcat(savepath,histname,ext);
            
        feat_saveas = strcat(savepath,histname,'_cost.mat');        
        
        load(source);
         poly_src = fullfile(folder,'polygons',strrep(histname,'_sc','.mat'));
         seg_src = fullfile(folder,'segments',strrep(histname,'_sc','_seg.mat'));
         load(poly_src);
         load(seg_src);
        
        
        if exist('context','var')
            
            % Compute Cost
            % -------------------------------------------------------------------------
                
            cost = segmentShapeContextCost(ref,context);            
            % -------------------------------------------------------------------------            
            % Compute Segment Angles
            
            P1 = polygon(1,:);
            seg_angles = zeros(1,numel(segments));
            for i = 1:numel(segments)
                ix = segments{i};
                P2 = polygon(ix(1),:);
                seg_angles(i) = angle2Points(P1,P2);
            end
            
            angle_diff = abs(seg_angles - ref_angles);
            
            total_cost = cost'+angle_diff;
            total_cost = norm(total_cost);
                
            
%             cmap = ['r'; 'y'; 'b'; 'g'; 'm'; 'k'; 'r'; 'y'];            
%             
%             figure(f);
%             grid_size = ceil(sqrt(numel(cost)));
%             for i = 1:numel(cost)                
%                 subplot(grid_size,grid_size,i)
%                 drawPolyline(polygon(segments{i},:),'Color',cmap(i,:),'LineWidth',1);
%                 title(strcat('Cost: ',num2str(cost(i))));
%                 axis equal;                
%             end
            
            save(feat_saveas,'cost','total_cost');
            
        end
    end
    
end

end