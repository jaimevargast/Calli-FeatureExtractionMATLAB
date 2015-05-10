function [ scaled_poly ] = scalePolyConstrained(poly)
%SCALEPOLY Scales polygon to fit within 2x2 square ([-1 1]) while preserving 
%aspect ratio
%

% Determine aspect ratio
w = max(poly(:,1)) - min(poly(:,1));
h = max(poly(:,2)) - min(poly(:,2));

if w<=h
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
else
    minx = min(poly(:,1));
    maxx = max(poly(:,1));

    scalingfactor = (maxx-minx)/2;
    midpoint_x = (minx + scalingfactor);

    scaled_poly(:,2) = (poly(:,2)-midpoint_x)./scalingfactor;
    scaled_poly(:,1) = (poly(:,1)-midpoint_x)./scalingfactor;

    miny = min(scaled_poly(:,2));
    maxy = max(scaled_poly(:,2));
    midpoint_y = miny+((maxy-miny)/2);
    scaled_poly(:,2) = scaled_poly(:,2)-midpoint_y;
end

end

