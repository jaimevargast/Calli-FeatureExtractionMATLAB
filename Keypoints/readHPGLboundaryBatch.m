function readHPGLboundaryBatch(directory)

%mkdir(directory,'keypoint descriptors');
%savepath = strcat(directory,'/keypoint descriptors/');
savepath = directory;

polys = dir(directory);

for f = 1:length(polys)
    smoothed_V2 = [];
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Parse the hpgl file
    if(strcmp(ext,'.plt'))
        f = strcat(directory,name,ext);
        [smoothed_V2] = readHPGLboundary(f) ;
        feat_saveas = strcat(savepath,name,'.mat');
        % SAVE        
        save(feat_saveas,'smoothed_V2');
    end
end



end


