clear all;

letter = './data/k expanded/';

scores = './scores/scores_k_expanded.txt';

ft = './data/k expanded/segment curvature length/';

sc_map = dlmread(scores); %score to filename map

%threshold scores to assign class label: s>=0.6 -> 1, 0 otherwise
sc_map(:,1) = [];
leg = find(sc_map(:,2)>=0.6);
illeg = find(sc_map(:,2)<0.6);

sc_map(leg,2) = 1;
sc_map(illeg,2) = 0;
% -------------------------------------------------------------------------
all_profiles = {};
all_lengths = [];
% Load features
for ii=1:size(sc_map,1)
    %load(fullfile(ft,strcat(num2str(sc_map(ii,1)),'_curv.mat')));
    %load(fullfile(ft,strcat(num2str(sc_map(ii,1)),'_len.mat')));
    load(fullfile(letter,'polygons',strcat(num2str(sc_map(ii,1)),'.mat')));
    load(fullfile(letter,'segments',strcat(num2str(sc_map(ii,1)),'_seg.mat')));    
    labels{ii,1} = sc_map(ii,2);
    [profiles,lengths] = segmentCurvatureLength(polygon,segments,100,0,0);
    all_profiles{ii,1} = profiles;
    all_lengths{ii,1} = lengths;   
end

%Visualize
for ii = 1:size(all_profiles,1)
    this_profile = all_profiles{ii,1};    
    this_len = all_lengths(ii,1);
    this_label = cell2mat(labels(ii,1));
        
    for jj=1:numel(this_profile) % should be consistent
        figure(jj);
        hold on;
        y =this_profile{jj}';
        x = [1:size(y,2)];
        if this_label            
            scatter(x,y,'o','MarkerEdgeColor','g');
            %plot(x,y,'Color','g');
        else
            scatter(x,y,'o','MarkerEdgeColor','r');
            %plot(x,y,'Color','r');
        end
        hold off;
    end
end

        
    

    
    
