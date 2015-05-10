function [profiles,lengths] = segmentCurvatureLength(polygon,segments,samplesize)

profiles = [];
lengths = [];

tot_len = polygonLength(polygon);

for i = 1:numel(segments)
    
    %extract segment indices
    ix = cell2mat(segments(i));
    
    % extract segment
    seg = polygon(ix,:);
    
    len = polylineLength(seg,'open')/tot_len;
    lengths = [lengths len];
    
    %Construct line segments
    P1 = seg;
    P2 = circshift(seg,[-1 0]);
    P3 = circshift(P2,[-1 0]);
    P1((end-1):end,:) = [];
    P2((end-1):end,:) = [];
    P3((end-1):end,:) = [];
    
    %COMPUTE TURNING ANGLES
    theta = angle3Points(P1,P2,P3);
    theta = pi-theta;

    %COMPUTE CURVATURE
    K = (sin(theta./2)).*2;
    K = [0; K; 0];    
    
    thisProfile = [];
    sum_k = 0;
    for ii = 1:size(ix,1)
        sum_k = sum_k + K(ii);
        if mod(ii,floor(size(ix,1)/samplesize))==0
            thisProfile = [thisProfile sum_k];
            sum_k=0;
        end
    end
    profiles = [profiles thisProfile];       
end
end