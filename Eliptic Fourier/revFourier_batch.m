function revFourier_batch(folder)
%FEFOURIER_BATCH Summary of this function goes here
%   Detailed explanation goes here

NumHarmonics = 15;
NumPoints = 200;

%mkdir(directory,'fourier shape descriptors');
%savepath = strcat(directory,'/fourier shape descriptors/');

fsds = dir(fullfile(folder,'fourier shape descriptors','*.mat'));
polys = dir(fullfile(folder, 'polygons','*.mat'));

for f = 1:length(polys)
    
    fsd = {};
           
    [pathstr,name,ext] = fileparts(polys(f).name);
    [fpathstr,fname,fext] = fileparts(fsds(f).name);
    
    
    % Load the polygon and fsd instance
    load(fullfile(folder, 'fourier shape descriptors',strcat(name,'_fsd.mat')));
    load(fullfile(folder, 'polygons',polys(f).name));
    
    %reconstruct the shape
    fsd = reshape(fsd,[],15);
    
    outln = rEfourier( fsd, NumHarmonics, NumPoints);
    
    shape = scalePoly([polygon(1).x polygon(1).y]);
    
    figure;
    hold on;
    scatter(outln(1,1),outln(1,2),'o','MarkerFaceColor','r');
    drawPolygon(outln,'-r');
    drawPolygon(shape,'-b');
    axis equal;
    hold off;
end

end

