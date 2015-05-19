function fullShapeContextCost_batch(folder)

%mkdir(folder,'shape context per segment');
savepath = strcat(folder,'full shape context\');

hists = dir(strcat(folder,'full shape context\*_sc.mat'));

%reference
load(strcat(folder,'full shape context\1_sc.mat'));
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
                
            cost = fullShapeContextCost(ref,context);            
            % -------------------------------------------------------------------------
            
            save(feat_saveas,'cost');
            
        end
    end
    
end

end