clear all
close all

input_folder = '..\letters and features\s';
output_folder = '..\letters and features\s\Hu moments descriptor';
mkdir(output_folder);
shapes_files = dir(fullfile(input_folder, '*.png'));

for file_ind = 1:size(shapes_files,1)
    
    filename = shapes_files(file_ind).name;
    im = imread(fullfile(input_folder,filename));
    [path, feature_file, ext] = fileparts(filename);
    
    % get the binary image from rgb
    im = rgb2gray(im);
    [r_b, c_b] = find(im < 128);
    [r_w, c_w] = find(im > 127);
    for i = 1:size(r_b,1)
        im(r_b(i),c_b(i)) = 0;
    end
    for i = 1:size(r_w,1)
        im(r_w(i),c_w(i)) = 1;
    end
    % im = im2bw(im,0.5);
    imshow(im,[]);
    title('binary image');

    M = invmoments(im);
    save(fullfile(output_folder, strcat(feature_file,'_hmd.mat')),'M');

end