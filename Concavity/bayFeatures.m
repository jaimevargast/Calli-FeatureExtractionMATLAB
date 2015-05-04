function [Area,Centroid,Width,Height] = bayFeatures(bays)

% % Visualize
%      hold on;
%      for i= 1:size(bays,2)
%          drawPolygon(bays(i).x,bays(i).y);
%      end
%      hold off;

A = [];
C = [];

for i = 1:size(bays,2)
    [c,a] = polygonCentroid(bays(i).x, bays(i).y);
    A = [A; a];
    C = [C; c];
end

%we only care about 5 largest
[B,I] = sort(A,1,'descend');

if size(B,1)>=5
    sup = 5;
else
    sup = size(B,1);
end

Area = [];
Centroid = [];
Width = [];
Height = [];

for i = 1:sup
    
    Area = [Area; B(i)];
    Centroid = [Centroid; C(I(i),:)];

    index = I(i);    
    width = max(bays(I(i)).x) - min(bays(I(i)).x);
    height = max(bays(I(i)).y) - min(bays(I(i)).y);
    Width = [Width; width];
    Height = [Height; height];
end

% Visualize
%     hold on;
%     for i = 1:sup
%         patch(bays(I(i)).x,bays(I(i)).y,'yellow');
%         % centroid
%         drawPoint(Centroid(i,:));
%     end
%     hold off;
end