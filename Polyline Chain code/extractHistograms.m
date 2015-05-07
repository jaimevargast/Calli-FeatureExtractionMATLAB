function extractHistograms(folder)

mkdir(folder,'chaincode histograms');
savepath = strcat(folder,'/chaincode histograms/');

polys = dir(strcat(folder,'polygons/*.mat'));

for f = 1:length(polys)
    
    conc = [];
    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Load the polygon instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(folder,'polygons\',name,ext);
        name
        feat_saveas = strcat(savepath,name,'_cchist.mat');
        
        load(source);
        
        if exist('polygon','var')
            
            P = [polygon(1).x polygon(1).y];
            cc_hist = polyChaincodeHistogram(P,0);           
            save(feat_saveas,'cc_hist');
        end
    end

end
        
end
        
