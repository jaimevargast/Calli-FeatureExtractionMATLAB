function [HD,len_diff,ixmap] =  SegmentCurvatureHausdorff(folder)

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

HD = []; % Hausdorff distance between this curvature and reference
len_diff = []; % difference between this length and reference
ixmap = {}; % filenames

for f = 1:size(ks,1)
    
    [pathstr,kname,ext] = fileparts(ks(f).name);
    lname = strrep(kname,'_curv','_len');
    
    ksource = strcat(folder,'segment curvature length\',kname,ext);
    lsource = strcat(folder,'segment curvature length\',lname,ext);
    
    load(ksource);
    load(lsource);
    this_HD = [];
    
    for i=1:numel(curvature) % one cell per segment
        
        hd = HausdorffDist(ref_k{i},curvature{i});
%         hd = norm(ref_k{i} - curvature{i});
        this_HD = [this_HD hd];
    end
    
    ix = strrep(kname,'_curv','');
    ixmap{f,1} = ix;
    HD = [HD; this_HD];
    
    this_len_diff = abs(len - ref_len);
    len_diff = [len_diff; this_len_diff];
end
end