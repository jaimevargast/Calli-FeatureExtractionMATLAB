function [] = pairwise_comparison_syntheticdata( images_dir, savepath )
%PAIRWISE_COMPARISON_SYNTHETICDATA Summary of this function goes here
%   Detailed explanation goes here

images_file = dir(fullfile(images_dir, '*.png'));
no_pairs = nchoosek(length(images_file),2);

if exist(savepath, 'file') == 0 % first time, beginning the test
    pairs = zeros(no_pairs,3);
    pairs_indices = randperm(no_pairs);

    counter = 1;
    for i = 1:length(images_file) - 1
        for j = i+1:length(images_file)
            pairs(counter, 1) = i;
            pairs(counter, 2) = j;
            counter = counter + 1;
        end
    end
    start = 1;
else % after crashes, if any
    load(savepath);
end

for i = start:no_pairs
    
    close all
    
    temp = rand(1,1);
    if temp < 0.5
        image1 = images_file(pairs(pairs_indices(i),1));
        image2 = images_file(pairs(pairs_indices(i),2));
    else
        image2 = images_file(pairs(pairs_indices(i),1));
        image1 = images_file(pairs(pairs_indices(i),2));
    end
    
    subplot(1,2,1);
    imshow(fullfile(images_dir, image1.name));
    subplot(1,2,2);
    imshow(fullfile(images_dir, image2.name));
    
    choice = input('select the more legibile one (press 1 or 2): ');
    pairs(pairs_indices(i),3) = choice;
    if mod(i,10) == 0
        display('number of tests done so far: ');
        display(i);
    end
    
    start = start + 1;
    save(savepath, 'pairs', 'images_file', 'pairs_indices', 'start');
end

% save(savepath, 'pairs', 'images_file');

end

