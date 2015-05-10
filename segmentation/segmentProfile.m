function profiles = segmentProfile(polygon,segments,samplesize,visualize)


profiles = [];
if visualize
    figure;
end
for i = 1:numel(segments)
    
    %extract segment indices
    ix = cell2mat(segments(i));
    
    %build a line from the segment starting point to ending point, and
    %sample uniformly
    baseline = [polygon(ix(1),:); polygon(ix(end),:)];
    basepoints = resamplePolyline(baseline,100);
    
    %Compute distances from points on base to points on segment
    seg = polygon(ix,:);
    rays = seg-basepoints;
    N = sqrt(sum(abs(rays).^2,2));
    
    % Norm discards sign but we need to know whether is above or below
    a = repmat(baseline(1,:),[length(seg) 1]);
    b = repmat(baseline(2,:),[length(seg) 1]);
    s = [b(:,1)-a(:,1)].*[seg(:,2)-a(:,2)] - [b(:,2)-a(:,2)].*[seg(:,1) - a(:,1)];
    s = sign(s);
    N = N.*s;
    
    if(visualize)    
        hold on;
        drawPolygon(polygon(ix,:));
        for ii = 1:size(rays,1)
            if s(ii)>0
                drawEdge(basepoints(ii,1),basepoints(ii,2),seg(ii,1),seg(ii,2),'Color','g');
            else
                drawEdge(basepoints(ii,1),basepoints(ii,2),seg(ii,1),seg(ii,2),'Color','r');
            end
        end
        hold off;
    end
    
    thisProfile = [];
    for ii = 1:size(ix,1)
        if mod(ii,floor(size(ix,1)/samplesize))==0
            thisProfile = [thisProfile N(ii,:)];
        end
    end
    profiles = [profiles thisProfile];   
    
end
end