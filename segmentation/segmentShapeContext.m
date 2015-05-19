function [aligned_segments,context] = segmentShapeContext(polygon,segments,visualize)
polygon = scalePolyConstrained(polygon);
NR = 5; %number of rings
NW = 8; %number of wedges
RMIN = 0.5;
RMAX = 2;
mean_dist_global=[];

aligned_segments = {};
context = {};

if visualize
    figure;    
end

for i=1:numel(segments)

    this_segment = polygon(segments{i},:);
    nsamp = size(this_segment,1);
    
    % Compute angle of BASE for each segment
    P1 = this_segment(1,:); %base from P1-P2
    P2 = this_segment(end,:);
    alpha = angle2Points(P1,P2);
    alpha = rad2deg(alpha);
    
    % Align to X-axis, with P1 at origin
    %Translate P1 to origin
    tform1 = affine2d([ 1       0       0
        0       1       0
        -P1(1) -P1(2)  1]);
    [S2] = transformPointsForward(tform1,this_segment);
    
    %Temporarily Rotate Polygon so it is aligned with X-axis
    tform2 = affine2d([  cosd(alpha) -sind(alpha)    0
        sind(alpha) cosd(alpha)     0
        0           0               1]);
    [S2] = transformPointsForward(tform2,S2);
    
    %Scale along x-axis to [0,1]
    minx = min(S2(:,1));
    maxx = max(S2(:,1));
    S2(:,1) = (S2(:,1) - minx)./(maxx - minx);
    S2(:,2) = (S2(:,2))./(maxx - minx);
    
%     % ===================
%     % Experiment: don't rotate, just scale
%     S2 = scalePolyConstrained(this_segment);
%     % ===================
    out_vec = zeros(1,nsamp);
    
    normals = LineNormals2D(S2);
    tangents = [-normals(:,2) normals(:,1)];
    tangent_angle = angle2Points(zeros(size(tangents,1),2),tangents);    
    
    [BH,mean_dist] = sc_compute(S2',tangent_angle',mean_dist_global,NW,NR,RMIN,RMAX,out_vec);
    %[BH,mean_dist] = sc_compute(S2',zeros(1,nsamp),mean_dist_global,NW,NR,RMIN,RMAX,out_vec);
    
    cmap = ['r'; 'y'; 'b'; 'g'; 'm'; 'k'; 'r'; 'y'];
    if visualize            
            subplot(4,2,1:4);
            hold on;
            drawPolyline(this_segment,'Color',cmap(i,:),'LineWidth',2,'Marker','*');           
            hold off;
            subplot(4,2,4+i);
            drawPolyline(S2,'Color',cmap(i,:),'LineWidth',2,'Marker','*');                       
    end         
    
    aligned_segments{i} = S2;     
     context{i} = BH;
end

if visualize
    subplot(4,2,1:4);
    axis equal;
    subplot(4,2,5);
    axis equal;
    subplot(4,2,6);
    axis equal;
    subplot(4,2,7);
    axis equal;
    subplot(4,2,8);
    axis equal;
end

end