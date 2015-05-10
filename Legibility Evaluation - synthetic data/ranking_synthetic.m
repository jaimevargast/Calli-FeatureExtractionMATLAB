function [] = ranking_synthetic(comparisons_file, savepath)

% now, use bradley terry to get the scores
load(comparisons_file);
counts = comparisons;

fixed_count_data = fix_counts(counts);
thresh = 2;

[s_ls_btl_fixed,P] = scale_ls_btl(fixed_count_data);

%normalizing results
min_val = min(s_ls_btl_fixed);
s_ls_btl_fixed = (s_ls_btl_fixed - min_val);
max_val = max(s_ls_btl_fixed);
s_ls_btl_fixed = s_ls_btl_fixed ./ max_val;

scores = s_ls_btl_fixed;

save(savepath, 'scores');

end