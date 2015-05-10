function fEfourier_batch(directory)
%FEFOURIER_BATCH Summary of this function goes here
%   Detailed explanation goes here

iNoOfHarmonicsAnalyse = 15;
bNormaliseSizeState = 1;
bNormaliseOrientationState = 1;

mkdir(directory,'fourier shape descriptors');
savepath = strcat(directory,'/fourier shape descriptors/');

polys = dir(strcat(directory, 'polygons\'));

%aux = struct('x',[],'y',[],'hole',[]);

for f = 1:length(polys)
    
    fsd = {};
    
    [pathstr,name,ext] = fileparts(polys(f).name);
    
    
    % Load the polygon instance
    if(strcmp(ext,'.mat'))
        source = strcat(name,ext);
        fsd_saveas = strcat(savepath,name,'_fsd.mat');
        
        load(strcat(directory, 'polygons\',source));
        
        if exist('polygon','var')
            outline = [polygon(1).x polygon(1).y];
            % Extract FSD
            rFSDs = fEfourier(outline, iNoOfHarmonicsAnalyse, bNormaliseSizeState, bNormaliseOrientationState);
            fsd = [];
            for col = 1:size(rFSDs,2)
                fsd = [fsd rFSDs(:,col).'];
            end
            save(fsd_saveas,'fsd');
            
        end
        
        
    end
    
    
    
    
    
    
    % Extract FSD
    %             rFSDs = fEfourier(outline, iNoOfHarmonicsAnalyse, bNormaliseSizeState, bNormaliseOrientationState);
    %
    %             save(fsd_saveas,'rFSDs');
    
end

end

