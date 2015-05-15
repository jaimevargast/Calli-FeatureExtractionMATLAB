function ft_vector = bayFeatures(chull,bays,visualize,reshape)

% clear all;
% clf;
% load('E:\dev\Calli-FeatureExtractionMATLAB\letters and features\s\polygons\2.mat')

if(visualize)
    figure;
end

%DEFINE AND VISUALIZE RADIAL AXES
%RX = [(0) (pi/6) (pi/3) (pi/2) (2*pi/3) (5*pi/6) (pi) (7*pi/6) (4*pi/3) (3*pi/2) (5*pi/3) (11*pi/6) (2*pi)]';
%ft_vector = zeros(12,10);
%DEFINE AND VISUALIZE RADIAL AXES
RX = [(0) (pi/4) (pi/2) (3*pi/4) (pi) (5*pi/4) (3*pi/2) (7*pi/4) (2*pi)]';




%Compute centroid and area of convex hull
[chull_c,chull_a] = polygonCentroid(chull(:,1),chull(:,2));
threshold = 0.005;

MP = [];    %base midpoints IN POLAR
ALPHA = []; %base angle
BBOX = {};  %bounding boxes
C = [];     %centroids
W = [];     %widths
H = [];     %heights
S = [];     %solidity
A = [];     %areas (relative to chull area)
COEFF = {}; %PCA coefficients (orientation)
K = [];
NORMS = {}; %line normals, for curvature visualization only
V = {};     %sub-sampled bay, for visualization

for i= 1:size(bays,2)
    
    % Compute angle of BASE for each bay Polygon
    bay = [bays(i).x bays(i).y]; %bay polygon
    P1 = [bays(i).x(1) bays(i).y(1)]; %base from P1-P2
    P2 = [bays(i).x(end) bays(i).y(end)];
    mp = (P1+P2)./2; %base midpoint;
    [th,rho] = cart2pol(mp(1),mp(2));
    if th<0
        th = (2*pi)+th;
    end
    MP = [MP; th rho];
    alpha = angle2Points(P1,P2);
    ALPHA = [ALPHA; alpha];
    alpha = rad2deg(alpha);
    
       
    %Translate P1 to origin
    tform1 = affine2d([ 1       0       0
        0       1       0
        -P1(1) -P1(2)  1]);
    [M2] = transformPointsForward(tform1,bay);
    
    %Temporarily Rotate Polygon so it is aligned with X-axis
    tform2 = affine2d([  cosd(alpha) -sind(alpha)    0
        sind(alpha) cosd(alpha)     0
        0           0               1]);
    [M2] = transformPointsForward(tform2,M2);
    
    %Compute bbox
    minx = min(M2(:,1));
    maxx = max(M2(:,1));
    miny = min(M2(:,2));
    maxy = max(M2(:,2));
    bbox = ([minx miny;
        maxx miny;
        maxx maxy;
        minx maxy;]);
    
    %Compute PCA
    M2 = resamplePolygon(M2,100);
    coeff = pca(M2);
    
    %Apply inverse transformation to Bbox and coeff
    bbox = transformPointsInverse(tform2,bbox);
    bbox = transformPointsInverse(tform1,bbox);
    BBOX = [BBOX; bbox];
    
    coeff = transformPointsInverse(tform2,coeff); %just rotation
    COEFF{i} = coeff*(-1);
    
    
    %Width and height of bounding box
    h = max(bbox(:,2)) - min(bbox(:,2));
    w = max(bbox(:,1)) - min(bbox(:,1));
    
    W = [W; w];
    H = [H; h];
    
    %Solidity of the bay polygon: area/bbox area
    bb_area = polygonArea(bbox);
    [bay_centroid,bay_area] = polygonCentroid(bay);
    [th,rho] = cart2pol(bay_centroid(1),bay_centroid(2));
    if th<0
        th = (2*pi)+th;
    end
    bc = [th rho];
    solidity = bay_area/bb_area;
    S = [S; solidity];
    C = [C; bc];
    %bay area/chull area
    a= bay_area/chull_a;
    A = [A; a];
    
    % Curvature profile
    %------------------------------------------------------------------
    bay = resamplePolyline(bay,10);
    k = LineCurvature2D(bay);
    nor = LineNormals2D(bay);
    %k = k./8000000;
    
    NORMS{i} = nor.*repmat(k,1,2);
    K = [K; k'];
    V{i} = bay;
    
%     %Construct line segments
%     P1 = bay;
%     P2 = circshift(bay,[-1 0]);
%     P3 = circshift(P2,[-1 0]);
%     P1((end-1):end,:) = [];
%     P2((end-1):end,:) = [];
%     P3((end-1):end,:) = [];
%     
%     %COMPUTE TURNING ANGLES
%     theta = angle3Points(P1,P2,P3);
%     theta = pi-theta;
% 
%     %COMPUTE CURVATURE
%     k = (sin(theta./2)).*2;
%     tempK = abs(k);
%     ix = find(tempK<0.00001);
%     k(ix) = 0;
%     K = [K; k'];
%     
end


%v_size = size(ALPHA,2) + size(C,2) + size(W,2) + size(H,2) + size(S,2) + size(A,2) + 4 + size(K,2); %size(COEFF,2)%
v_size = size(C,2) + size(ALPHA,2) + size(A,2) + size(K,2); %size(COEFF,2)%
ft_vector = zeros(8,v_size);

if(visualize)
    hold on;
    axis([-1 1 -1 1]);
    for i = 1:length(RX)-1
        ray = createRay([0,0],RX(i));
        drawRay(ray,'LineStyle',':');
    end
    hold off;
end

for i = 1:length(RX)-1
    %find candidates
    lb = RX(i);
    ub = RX(i+1);
    [ind] = find( MP(:,1)>lb&MP(:,1)<=ub);
    
    %select largest candidate
    [c,I] = max(A(ind));
    
    I = ind(I);
    
    %discard if smaller than threshold
    if ~(isempty(I))
        if (A(I)<threshold)
            ft_vector(i,:) = zeros(1,v_size);
        else %selected
            coeff = COEFF{I};
            constrained_C = C(I,1) - lb; %constrain angle
            %ru = [constrained_C C(I,2) W(I) H(I) A(I) S(I) coeff(1,:) coeff(2,:) ALPHA(I) K(I,:)];
            ru = [constrained_C C(I,2) ALPHA(I) A(I) K(I,:)];
            ft_vector(i,:) = ru;
            
            %Visualize
            if(visualize)
                X = bays(I).x';
                Y = bays(I).y';
                [mpx,mpy] = pol2cart(MP(I,1),MP(I,2));
                [cx,cy] = pol2cart(C(I,1),C(I,2));
                major = [cx cy; cx+coeff(1,1) cy+coeff(1,2)];
                minor = [cx cy; cx+coeff(2,1) cy+coeff(2,2)];
                
                verts = V{I};
                norms = NORMS{I};                
                
                hold on;
                patch(X,Y,'g');
                scatter(mpx,mpy,'o','MarkerFaceColor','red');
                scatter(cx,cy,'o','MarkerFaceColor','blue');
                plot([verts(:,1) verts(:,1)+norms(:,1)]',[verts(:,2) verts(:,2)+norms(:,2)]','b','LineWidth',2);            
                drawPolyline(verts);
                %drawPolyline(major,'Color','g');
                %drawPolyline(minor,'Color','r');
                %drawPolygon(BBOX(I));
                hold off;
            end
        end
    else
        ft_vector(i,:) = zeros(1,v_size);
    end
end

%Reshape feature vector
if reshape
    dummy = [];
    for row = 1:size(ft_vector,1)
        dummy = [dummy ft_vector(row,:)];
    end
    ft_vector = dummy;
end

end