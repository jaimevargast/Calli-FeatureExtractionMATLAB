load('E:\dev\Calli-FeatureExtractionMATLAB\data\synthetic s\polygons\0.mat');

polygon = scalePoly([polygon(1).x polygon(1).y]);
len = polygonLength(polygon);

numPoints = floor(len/.0025);

polygon = resamplePolygon(polygon,numPoints);

drawPolygon(polygon,'Marker','.');

cc = [];

%
%   used direction-to-code convention is:       3  2  1
%                                                \ | /
%                                             4 -- P -- 0
%                                                / | \
%                                               5  6  7
%   

for i = 1:length(polygon)
    P1 = polygon(i,:);
    if i==length(polygon)
        P2 = polygon(1,:);
    else
        P2 = polygon(i+1,:);
    end
    
    angle = angle2Points(P1,P2);
    
    % REDO THIS, ranges should be at 22.5 intervals
    if      angle>=0        &&  angle<(pi/4)
        cc = [cc; 0];
    elseif  angle>=(pi/4)   &&  angle<(pi/2)
        cc = [cc; 1];
    elseif  angle>=(pi/2)   &&  angle<(3*pi/4)
        cc = [cc; 2];
    elseif  angle>=(3*pi/4) &&  angle<(pi)
        cc = [cc; 3];
    
end



