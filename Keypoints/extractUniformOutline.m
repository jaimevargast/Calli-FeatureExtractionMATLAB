clear all;
load('E:\dev\Calli-FeatureExtractionMATLAB\letters and features\s\1.mat')

% Scaling and centering procedure [ORIGINAL MESH]
% -------------------------------------------------------------------------
% Step 1: Constrain y-axis to [-1,1]
% Step 2: Apply same scaling factor to x-axis, and recenter x axis at
% midpoint
miny = min(lettermesh.V(:,2));
maxy = max(lettermesh.V(:,2));

scalingfactor = (maxy-miny)/2;
midpoint_y = (miny + scalingfactor);

scaled_originalV(:,2) = (lettermesh.V(:,2)-midpoint_y)./scalingfactor;
scaled_originalV(:,1) = (lettermesh.V(:,1)-midpoint_y)./scalingfactor;

minx = min(lettermesh.V(:,1));
maxx = max(lettermesh.V(:,1));
midpoint_x = minx+((maxx-minx)/2);
scaled_originalV(:,1) = lettermesh.V(:,1)-midpoint_x;
% -------------------------------------------------------------------------

% Scaling and centering procedure [DEFORMED MESH]
% -------------------------------------------------------------------------
% Step 1: Constrain y-axis to [-1,1]
% Step 2: Apply same scaling factor to x-axis, and recenter x axis at
% midpoint
miny = min(smoothed_V2(:,2));
maxy = max(smoothed_V2(:,2));

scalingfactor = (maxy-miny)/2;
midpoint_y = (miny + scalingfactor);

scaled_deformedV(:,2) = (smoothed_V2(:,2)-midpoint_y)./scalingfactor;
scaled_deformedV(:,1) = (smoothed_V2(:,1)-midpoint_y)./scalingfactor;

minx = min(smoothed_V2(:,1));
maxx = max(smoothed_V2(:,1));
midpoint_x = minx+((maxx-minx)/2);
scaled_deformedV(:,1) = smoothed_V2(:,1)-midpoint_x;
% -------------------------------------------------------------------------

%Sample
%--------------------------------------------------------------------------
Moving = [];
Key_ix = [];

for i = 1:length(lettermesh.bnd_V)
    if mod(i,3)==0
        Key_ix = [Key_ix; lettermesh.bnd_V(i)];
    end
end

Ref = scaled_originalV(Key_ix,:);
Moving = scaled_deformedV(Key_ix,:);
%--------------------------------------------------------------------------

%Compute translation
%--------------------------------------------------------------------------
tr = Moving - Ref;
%--------------------------------------------------------------------------

    
%Visualize
colors = ['y','m','c','r','g','b'];

subplot(1,2,1);
drawPolygon(scaled_originalV(lettermesh.bnd_V,:));
hold on;

subplot(1,2,2);
drawPolygon(scaled_deformedV(lettermesh.bnd_V,:));
hold on;

b = num2str([1:length(Moving)]');
b = cellstr(b);
dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points

for i=1:length(Moving)
    cix = mod(i,6); %color index
    if cix==0
        cix=6;
    end
    subplot(1,2,1);
    scatter(Ref(i,1),Ref(i,2),'Marker','d','MarkerFaceColor',colors(cix));
    if (mod(i,5)==0)||(i==1)
        text(Ref(i,1)+dx,Ref(i,2)+dy,b(i),'FontSize',6);
    end
    
    subplot(1,2,2);
    scatter(Moving(i,1),Moving(i,2),'Marker','o','MarkerFaceColor',colors(cix));
    if (mod(i,5)==0)||(i==1)
        text(Moving(i,1)+dx,Moving(i,2)+dy,b(i),'FontSize',6);
    end
end

subplot(1,2,1);
hold off;

subplot (1,2,2);
hold off;



