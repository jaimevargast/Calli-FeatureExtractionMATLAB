clear all
close all

images_dir_ = '..\data\synthetic k';
images_olddir_ = '..\data\synthetic k\old';
images_newdir_ = '..\data\synthetic k\new';
images_file_ = dir(fullfile(images_dir_, '*.png'));
oldimages_file_ = dir(fullfile(images_olddir_, '*.png'));
newimages_file_ = dir(fullfile(images_newdir_, '*.png'));

no_newpairs_ = nchoosek(length(newimages_file_),2) + ...
    length(newimages_file_) * length(oldimages_file_);
no_oldpairs_ = nchoosek(length(oldimages_file_),2);
no_pairs_ = nchoosek(length(images_file_),2);

user1_results = zeros(no_pairs_, 5);
user2_results = zeros(no_pairs_, 5);
counts = zeros(length(images_file_), length(images_file_));

%% zeinab's opinion
pairwise_results_file = 'pairs_result_zeinab_new.mat';
load(pairwise_results_file);
user1_results(1:no_newpairs_, 3:5) = pairs;

pairwise_results_file = 'pairs_result_zeinab.mat';
load(pairwise_results_file);
user1_results(no_newpairs_ + 1:no_pairs_, 3:5) = pairs;

for i = 1:no_pairs_
    ind1 = user1_results(i, 3);
    ind2 = user1_results(i, 4);
    
    if ind1 < 35
        [path, name1, ext] = fileparts(oldimages_file_(ind1).name);
    else
        [path, name1, ext] = fileparts(newimages_file_(ind1-34).name);
    end
    
    if ind2 < 35
        [path, name2, ext] = fileparts(oldimages_file_(ind2).name);
    else
        [path, name2, ext] = fileparts(newimages_file_(ind2-34).name);
    end
    
    user1_results(i, 1) = str2num(name1);
    user1_results(i, 2) = str2num(name2);
end

%% jaime's opinion
pairwise_results_file = 'pairs_result_jaime.mat';
load(pairwise_results_file);
user2_results(:, 3:5) = pairs;

for i = 1:no_pairs_
    ind1 = user2_results(i, 3);
    ind2 = user2_results(i, 4);
    
    [path, name1, ext] = fileparts(images_file_(ind1).name);
    [path, name2, ext] = fileparts(images_file_(ind2).name);
    
    user2_results(i, 1) = str2num(name1);
    user2_results(i, 2) = str2num(name2);
end

%% mapping filenames to indices
mapping = zeros(length(images_file_),1);
for i = 1:length(images_file_)
    [path, filename, ext] = fileparts(images_file_(i).name);
    mapping(i) = str2num(filename);
end

%% aggregate the results into counts
results{1} = user1_results;
results{2} = user2_results;

for i = 1:length(results)
    res = results{i};
    for j = 1:size(res,1)
        ind1 = find (mapping == res(j,1));
        ind2 = find (mapping == res(j,2));
        if (res(j,5) == 1)
            counts(ind1, ind2) = counts(ind1, ind2) + 1;
        else
            counts(ind2, ind1) = counts(ind2, ind1) + 1;
        end
    end
end

