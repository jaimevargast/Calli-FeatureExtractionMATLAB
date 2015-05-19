function segmentShapeContextCost_batch(folder)

%mkdir(folder,'shape context per segment');
savepath = strcat(folder,'shape context per segment\');

hists = dir(strcat(folder,'shape context per segment\*_sc.mat'));

%reference
load(strcat(folder,'shape context per segment\1_sc.mat'));
ref = context;

cost = [];

for f = 1:size(hists,1)
        
    [pathstr,histname,ext] = fileparts(hists(f).name);
    
    %Load the histogram
    if(strcmp(ext,'.mat'))
       
        source = strcat(savepath,histname,ext);
            
        feat_saveas = strcat(savepath,histname,'_cost.mat');        
        
        load(source);        
        
        if exist('context','var')
            
            % Compute Cost
            % -------------------------------------------------------------------------
                
            cost = segmentShapeContextCost(ref,context);
            total_cost = norm(cost);
            % -------------------------------------------------------------------------
            
            save(feat_saveas,'cost','total_cost');
            
        end
    end
    
end

end