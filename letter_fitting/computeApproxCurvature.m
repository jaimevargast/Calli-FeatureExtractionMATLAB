function pca_features = computeApproxCurvature(contour_polygon, feature_pts, neighbor_sz)

total_num = size(contour_polygon.x,1);

center_ids = feature_pts.ids;

% generate segments
feature_num = length(center_ids);
segment_ids = cell(feature_num, 1);
seg_length = 2*neighbor_sz+1;

for i=1:feature_num
    curr_segment = zeros(seg_length,1);
    curr_segment(neighbor_sz + 1) = center_ids(i);
       
    for ni=1:neighbor_sz
        % assign id of the left part
        left_id = center_ids(i) - neighbor_sz + ni -1;
        if left_id < 1
            left_id = left_id + total_num;
        end
        curr_segment(ni) = left_id;
        
        % assign id of the right part
        right_id = center_ids(i) + ni;
        if right_id > total_num
            right_id = right_id - total_num;
        end
        curr_segment(ni + neighbor_sz +1) = right_id;
        
    end
    segment_ids{i} = curr_segment;
end

pca_features = zeros(feature_num, 3);
for i=1:feature_num
   seg_pts = [contour_polygon.x(segment_ids{i}), contour_polygon.y(segment_ids{i})];
   [pc, score, latent] = princomp(seg_pts); 
   pca_features(i,1) = feature_pts.signs(i)*latent(2)/(latent(1)+latent(2));
end

% % pca feature of left part
% for i=1:feature_num
%    seg_pts = [contour_polygon.x(segments{i}(1:neighbor_sz+1)), contour_polygon.y(segments{i}(1:neighbor_sz+1))];
%    [pc, score, latent] = princomp(seg_pts); 
%    pca_features(i,2) = 0.5*feature_pts.signs(i)*latent(2)/(latent(1)+latent(2));
% end
% % pca feature of left part 
% for i=1:feature_num
%    seg_pts = [contour_polygon.x(segments{i}(neighbor_sz+1:seg_length)), contour_polygon.y(segments{i}(neighbor_sz+1:seg_length))];
%    [pc, score, latent] = princomp(seg_pts); 
%    pca_features(i,3) = 0.5*feature_pts.signs(i)*latent(2)/(latent(1)+latent(2));
% end

end