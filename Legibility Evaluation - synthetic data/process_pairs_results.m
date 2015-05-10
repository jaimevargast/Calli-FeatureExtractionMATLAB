function [] = process_pairs_results (source_file, output_file, reset_comparisons)

load(source_file);

no_shapes = length(images_file);
no_pairs = size(pairs, 1);
if reset_comparisons == 1
    comparisons = zeros(no_shapes, no_shapes);
else
    load(output_file);
end

for i = 1:no_pairs
    if pairs(i,3) == 1 % the first one beats the second
        comparisons(pairs(i,1), pairs(i,2)) = comparisons(pairs(i,1), pairs(i,2)) + 1;
    else
        comparisons(pairs(i,2), pairs(i,1)) = comparisons(pairs(i,2), pairs(i,1)) + 1;
    end
end

save(output_file, 'comparisons');

end