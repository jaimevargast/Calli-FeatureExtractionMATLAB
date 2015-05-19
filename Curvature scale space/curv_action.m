% This program processes the entire Weizmann action dataset,
% (i.e., http://www.wisdom.weizmann.ac.il/~vision/SpaceTimeActions.html), using
% the contours from each of the binary masks, computers a robust Curvature Scale
% Space (CSS) representation (i.e., A. Rattarangsi, and R. T. Chin, "Scale-based
% detection of corners of planar curves," Pattern Analysis and Machine
% Intelligence, vol. 14, pp. 430-449, Apr. 1992.)
% 
% It will loop through every actor and every action of the dataset.
%
% Written by Richard Xu @UTS - email, yida.xu@uts.edu.au
% ----------------------------------------------------------------------

clc;
clear;

% This is the Weizmann dataset (the binary mask)
load('weizmann_masks.mat');
names = fieldnames (aligned_masks);

num_activity = 10;
num_actors = 9;

t_index = 1;

for n_index = 1:size(names)
    if n_index ~= 56 && n_index ~= 59 && n_index ~= 61
        filtered_names (t_index) = names( n_index );
        t_index = t_index + 1;
    end
end


N = 100;
DISPLAY_STEP = 2;
DISPLAY_ORIGINAL = 1;
MAX_SUBPLOT = 6;

for actor = 1:num_actors 
    for activity =1:num_activity
        actor_activity_index = activity + (actor-1) * num_activity;

        is_debug_mode = 0;
        contours_action_sequence = get_action_frame_contour(aligned_masks, filtered_names, actor_activity_index, N);
        
        for t = 1:length(contours_action_sequence)
    
            CSSIFunction(contours_action_sequence(t).contour, [ names{actor_activity_index} ' T = '  num2str(t)], DISPLAY_ORIGINAL, DISPLAY_STEP, MAX_SUBPLOT, 120, 0.1);
    
        end

    end
end