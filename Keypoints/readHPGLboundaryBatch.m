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
        [smoothed_V2] = readHPGLboundary(strcat(pathstr,name,ext)) ;
        feat_saveas = strcat(savepath,name,'.mat');
        % SAVE        
        save(feat_saveas,'smoothed_V2');
    end
end



end


