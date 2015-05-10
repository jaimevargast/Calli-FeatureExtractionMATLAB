function [] = extractChainCodeSamples( folder )
%EXTRACTCHAINCODESAMPLES Summary of this function goes here
%   Detailed explanation goes here

mkdir(folder,'polyline chain code');
savepath = strcat(folder,'polyline chain code\');

polys = dir(strcat(folder,'hpgl\*.mat'));

for f = 1:length(polys)
    
%     conc = [];
    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Load the polygon instance
    if(strcmp(ext,'.mat'))
        
        source = strcat(folder,'hpgl\',name,ext);
        name
        feat_saveas = strcat(savepath,name,'_polycc.mat');
        
        load(source);
        
        if exist('smoothed_V2','var')
            
%             P = [smoothed_V2( polygon(1).y];
            cc_sampled = polyChainCodeSampled(smoothed_V2, 100);           
            save(feat_saveas,'cc_sampled');
        end
    end

end

end

