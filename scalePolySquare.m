function [ scaled_poly ] = scalePolySquare(poly)
%SCALEPOLY Scales polygon so both axes are constrained to [-1,1] and discards
%aspect ratio
%

miny = min(poly(:,2));
maxy = max(poly(:,2));
scaled_poly(:,2) = ((poly(:,2)-miny)./(maxy-miny) - 0.5) *2;


minx = min(poly(:,1));
maxx = max(poly(:,1));
scaled_poly(:,1) = ((poly(:,1)-minx)./(maxx-minx) - 0.5) *2;

end

