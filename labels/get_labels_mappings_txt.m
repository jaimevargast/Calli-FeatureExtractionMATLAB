function [] = get_labels_mappings_txt(inputfile)

input_dir = '..\scores\';

[indices, mapping, labels] = textread(strcat(input_dir, inputfile));

[path, name, ext] = fileparts(inputfile);
scores_save = strcat(name, '.mat');
mappings_save = strcat('mapping_',name,'.mat');

save(scores_save, 'labels');
save(mappings_save, 'mapping');

end