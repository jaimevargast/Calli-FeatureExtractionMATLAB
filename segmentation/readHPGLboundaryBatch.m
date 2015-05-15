function readHPGLboundaryBatch(directory)

%mkdir(directory,'keypoint descriptors');
%savepath = strcat(directory,'/keypoint descriptors/');
savepath = directory;

polys = dir(directory);

for f = 1:length(polys)    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    % Parse the hpgl file
    if(strcmp(ext,'.plt'))
%     if(strcmp(ext,'.plt') && ~isempty(strfind(name, 'test')))
        file = strcat(directory,name,ext);
        [polygon,segments] = readHPGLboundary(file) ;
        feat_saveas = strcat(savepath,name,'.mat');
        seg_saveas = strcat(savepath,name,'_seg.mat');
        % SAVE        
        save(feat_saveas,'polygon');
        save(seg_saveas,'segments');
    end
end



end


