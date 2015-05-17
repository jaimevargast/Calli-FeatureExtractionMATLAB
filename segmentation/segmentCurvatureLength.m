function [profiles,lengths] = segmentCurvatureLength(polygon,segments,samplesize,visualize,reshape)

if reshape
    profiles = [];
else
    profiles = {};
end

lengths = [];

tot_len = polygonLength(polygon);

if visualize
    cmap = lines(size(segments,2));
    figure;
    hold on;   
end

for i = 1:numel(segments)
    
    %extract segment indices
    ix = cell2mat(segments(i));
    
    % extract segment
    seg = polygon(ix,:);
    
    len = polylineLength(seg,'open')/tot_len;
    lengths = [lengths len];
    
    if visualize
        drawPolyline(seg,'Color','b','LineWidth',0.5);
    end
    
    %Downsample
    seg = resamplePolyline(seg,samplesize+2);
    
    K = DiscretePolylineCurvature2D(seg);
    tempK = abs(K);
    ix = find(tempK<0.00001);
    K(ix) = 0;
    
    if visualize        
            labels = num2str([0; K; 0],'%.4g');
            labels = cellstr(labels);
            dx = 0.01; dy = 0.01;            
            drawPolyline(seg,'Color',cmap(i,:),'LineWidth',2,'Marker','*');
            text([seg(:,1)],[seg(:,2)],labels,'FontSize',10);                
    end
    
    
    %K = [0; K; 0];    
    
%     thisProfile = [];
%     sum_k = 0;
%     for ii = 1:size(ix,1)
%         sum_k = sum_k + K(ii);
%         if mod(ii,floor(size(ix,1)/samplesize))==0
%             thisProfile = [thisProfile sum_k];
%             sum_k=0;
%         end
%     end
    if reshape 
        profiles = [profiles K'];       
    else
        profiles{i,1} = K;
    end
end
end