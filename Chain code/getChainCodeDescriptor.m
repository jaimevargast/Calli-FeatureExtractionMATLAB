clear all
close all

input_folder = '..\letters and features\synthetic s';
output_folder = '..\letters and features\synthetic s\Chain code';
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
        im(r_b(i),c_b(i)) = 1;
    end
    for i = 1:size(r_w,1)
        im(r_w(i),c_w(i)) = 0;
    end
    % im = im2bw(im,0.5);
%     imshow(im,[]);
%     title('binary image');

    [B,L] = bwboundaries(im, 8);
    
    imshow(label2rgb(L, @jet, [.5 .5 .5]))
    hold on
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
    end
    
    % for this specific data set, synthetic s
    if length(B) > 1
        boundary = B{2};
    else
        boundary = B{1};
    end
    
    cc = chaincode(boundary);
    sample_size = 50;
    sample_step = size(cc.code, 1) / sample_size;
    cc_sampled = cc.code(sample_step : sample_step : sample_step * sample_size);
    
    save(fullfile(output_folder, strcat(feature_file,'_cc.mat')),'cc_sampled');

end