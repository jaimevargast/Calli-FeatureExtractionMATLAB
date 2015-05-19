% this function sub-samples N points

function sampled_boundary = equal_arclength_N_points (boundary, N);

% compute the derivatives
d_boundary(:,1) = boundary(2:size(boundary,1),1) - boundary(1:size(boundary,1)-1,1);
d_boundary(:,2) = boundary(2:size(boundary,1),2) - boundary(1:size(boundary,1)-1,2);


% compute arclength for every point
arclength(1) = 0;
for u = 1: size(d_boundary,1)
    arclength(u+1) = arclength(u) + sqrt(d_boundary(u,1)^2 + d_boundary(u,2)^2);
end

sampled_arclength(1) = 0;
sampled_arclength(2:N) = (1:N-1) * ( arclength(length(arclength))/(N-1));

arclength_indices = dsearchn(arclength', sampled_arclength');

sampled_boundary = boundary(arclength_indices,:);

