function [HD,ixmap] =  SegmentCurvatureHausdorff(folder)

savepath = strcat(folder);

polys = dir(strcat(folder,'polygons\*.mat'));
segs = dir(strcat(folder,'segments\*.mat'));

ks = dir(strcat(folder,'segment curvature length\*_curv.mat'));
lens = dir(strcat(folder,'segment curvature length\*_len.mat'));

curvature = {};
load(strcat(folder,'segment curvature length\1_curv.mat'));
load(strcat(folder,'segment curvature length\1_len.mat'));

ref_k = curvature;
ref_len = len;

% 
% ref_polygon = polygon;
% ref_seg = segments;
% if ~isPolygonCCW(ref_polygon)
%     ref_polygon = reversePolygon(ref_polygon);
% end
% 
% 
% load('E:\dev\Calli-FeatureExtractionMATLAB\data\s expanded\polygons\4.mat');
% load('E:\dev\Calli-FeatureExtractionMATLAB\data\s expanded\segments\4_seg.mat');
% 
% if ~isPolygonCCW(polygon)
%     polygon = reversePolygon(polygon);
% end


%ref_curv = {};
%def_curv = {};
HD = [];
ixmap = {};

%polygon = scalePolyConstrained(polygon);
%ref_polygon = scalePolyConstrained(ref_polygon);

for f = 1:size(ks,1)
    
    [pathstr,kname,ext] = fileparts(ks(f).name);
    lname = strrep(kname,'_curv','_len');
    
    ksource = strcat(folder,'segment curvature length\',kname,ext);
    lsource = strcat(folder,'segment curvature length\',lname,ext);
           
    load(ksource);
    load(lsource);       
    this_HD = [];
        
for i=1:numel(curvature) % one cell per segment
% %     
% %     
% %     
% %     ref = ref_polygon(segments{i},:);
% %     segment = polygon(segments{i},:);
% %     ref_curv{i} = DiscretePolylineCurvature2D(ref);
% %     def_curv{i} = DiscretePolylineCurvature2D(segment);
%     figure;
%     subplot(1,2,1);
%     hold on;
%     drawPolyline(ref,'Color','b');
%     drawPolyline(segment,'Color','g');
%     hold off;
%     subplot(1,2,2);
%     x = [1:size(ref_curv{i},1)];
%     hold on;
%     plot(x,ref_curv{i},'Color','b');
%     plot(x,def_curv{i},'Color','g');
%     hold off;    
    hd = HausdorffDist(ref_k{i},curvature{i});
    this_HD = [this_HD hd];
end
    ix = strrep(kname,'_curv','');
    ixmap{f,1} = ix;
    HD = [HD; this_HD];

end
end