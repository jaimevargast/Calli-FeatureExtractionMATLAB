function css_distance = getCSSDistance(contour, ref_contour, threshold, max_sigma, sigma_step)

maxima_indices = getCSS(contour, threshold, max_sigma, sigma_step);
ref_maxima_indices = getCSS(ref_contour, threshold, max_sigma, sigma_step);

% remove duplicate indices and sort
maxima_indices = unique(maxima_indices);
ref_maxima_indices = unique(ref_maxima_indices);

size_css = length(maxima_indices);
size_ref_css = length(ref_maxima_indices);

if size_css == size_ref_css % two contours have the same number of maximas
    css_distance = sum( abs( maxima_indices - ref_maxima_indices ) );
    
elseif size_css > size_ref_css % this contour has more maximas than the reference
    size_diff = size_css - size_ref_css;
    combinations = combnk(1:size_css, size_diff);
    css_distance = flintmax;
    % try all combinations to get the minimum distance
    for i = 1:size(combinations, 1)
        new_indices = setdiff([1:size_css], combinations(i,:));
        distance = sum( abs( maxima_indices(new_indices) - ref_maxima_indices ) );
        if distance < css_distance
            css_distance = distance;
        end
    end
    
else % this contour has less maximas than the reference
    size_diff = size_ref_css - size_css;
    combinations = combnk(1:size_ref_css, size_diff);
    css_distance = flintmax;
    for i = 1:size(combinations, 1)
        new_indices = setdiff([1:size_ref_css], combinations(i,:));
        distance = sum( abs( ref_maxima_indices(new_indices) - maxima_indices ) );
        if distance < css_distance
            css_distance = distance;
        end
    end
    
end