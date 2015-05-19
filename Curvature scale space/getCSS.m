function maxima_indices = getCSS(contour, threshold, max_sigma, sigma_step)

% get the css image
cssi = CSSIFunction (contour, '', 1, floor(( (max_sigma - 1) / sigma_step + 1) / 6), 6, max_sigma, sigma_step);

% find maximas
zero_crossings_all = [];
sigmas_all = [];

for i = 1:length(cssi)
    new_zero_crossings = cssi(i).zero_crossings;
    zero_crossings_all = [zero_crossings_all, new_zero_crossings];
    sigmas_all = [sigmas_all, repmat(cssi(i).sigma, [1 length(new_zero_crossings)])];
end

maxima_indices = [];
for i = 1:size(contour, 1)
    maxima_candidates = find(zero_crossings_all == i);
    for j = 1:length(maxima_candidates)
        if sigmas_all(maxima_candidates(j)) > threshold
            maxima_indices = [maxima_indices, i];
        end
    end
end

end