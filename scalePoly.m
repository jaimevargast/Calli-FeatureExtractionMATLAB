function [ scaled_poly ] = scalePoly(poly)
%SCALEPOLY Scales polygon so y-axis is constrained to [-1,1] while
%preserving aspect ratio
%

% Scaling and centering procedure [ORIGINAL MESH]
% -------------------------------------------------------------------------
% Step 1: Constrain y-axis to [-1,1]
% Step 2: Apply same scaling factor to x-axis, and recenter x axis at
% midpoint
miny = min(poly(:,2));
maxy = max(poly(:,2));

scalingfactor = (maxy-miny)/2;
midpoint_y = (miny + scalingfactor);

scaled_poly(:,2) = (poly(:,2)-midpoint_y)./scalingfactor;
scaled_poly(:,1) = (poly(:,1)-midpoint_y)./scalingfactor;

minx = min(scaled_poly(:,1));
maxx = max(scaled_poly(:,1));
midpoint_x = minx+((maxx-minx)/2);
scaled_poly(:,1) = scaled_poly(:,1)-midpoint_x;

end

