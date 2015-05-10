function ccw = isPolygonCCW(polygon)
% orientation = 1 if counter-clockwise
%               0 otherwise

    P1 = polygon;
    P2 = circshift(polygon,[-1 0]);
    
    tot = sum([P2(:,1)-P1(:,1)].*[P2(:,2)+P1(:,2)]);
    
    if(tot>0)
        ccw = 1;
    else
        ccw = -1;
    end
end