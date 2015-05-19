% This function  converts the mask image to the contour
% Input:
%       aligned_masks           - the mask binary image
%       filtered_names          - the descriptions of all binary images
%       actor_activity_index    - which (index) of mask image to convert
%                           N   - number of contour points                       
% Output:
%       sampled_boundaries      - array of 2d points represent the contour
% Written by Richard Xu @UTS - email, yida.xu@uts.edu.au
% ----------------------------------------------------------------------


function sampled_boundaries = get_action_frame_contour(aligned_masks, filtered_names, actor_activity_index, N)


    Colours = [1.0, 0.0, 0.0];
    Colours = cat (1, Colours, [0.0,1.0,1.0]);
    Colours = cat (1, Colours, [0.5,0.5,0.5]);
    Colours = cat (1, Colours, [0.0,0.0,1.0]);
    Colours = cat (1, Colours, [1.0,0.0,1.0]);
 	
    img = getfield(aligned_masks,filtered_names{actor_activity_index});
    
    T = size(img,3);

    for Ti = 1:T
     
        [B,L] = bwboundaries(img(:,:,Ti),'noholes');
               
        max_contour_num = -100;
        max_index = 1;
        
        for k = 1:length(B)
            
            boundary = B{k};
            
            if size(boundary,1) > max_contour_num
                max_index = k; 
                max_contour_num = size(boundary,1);
             end
            
        end
        
        boundary = B{max_index};

        boundary = circshift(boundary, [0 1]);  
        
        sampled_boundary = equal_arclength_N_points (boundary, N);
        
        [min_v min_index] = min (sampled_boundary(:,2));
        sampled_boundary_shift = circshift(sampled_boundary, [-(min_index-1) 0]);
        
       
        sampled_boundaries(Ti).contour = sampled_boundary_shift;
        
    end
        

    clear X Y X_top Y_top X_bottom Y_bottom X_left Y_left X_right Y_right big_X d_boundary arclength Temp


end