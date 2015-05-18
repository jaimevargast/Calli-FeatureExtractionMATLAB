clear all;

letter = './data/s expanded/';

scores = './scores/scores_s_expanded.txt';

ft = './data/s expanded/concavity descriptors test/';

sc_map = dlmread(scores); %score to filename map

%threshold scores to assign class label: s>=0.6 -> 1, 0 otherwise
sc_map(:,1) = [];
leg = find(sc_map(:,2)>=0.6);
illeg = find(sc_map(:,2)<0.6);

sc_map(leg,2) = 1;
sc_map(illeg,2) = 0;
% -------------------------------------------------------------------------

all_features = {};

% Load features

for ii=1:size(sc_map,1)
    %load(fullfile(ft,strcat(num2str(sc_map(ii,1)),'_curv.mat')));
    %load(fullfile(ft,strcat(num2str(sc_map(ii,1)),'_len.mat')));
    load(fullfile(letter,'polygons',strcat(num2str(sc_map(ii,1)),'.mat')));
    labels{ii,1} = sc_map(ii,2);
    % Compute Features
    % -------------------------------------------------------------------------
    P = polygon;
    P = scalePoly(P);            
    [chull,bays] = extractConcavities(P);
    ft_vector = bayFeatures(chull,bays,0,0);
    % -------------------------------------------------------------------------
   all_features{ii,1} = ft_vector;

end

%Visualize
for ii = 1:size(all_features,1)
    this_feat = all_features{ii,1};        
    this_label = cell2mat(labels(ii,1));

%     figure(1);
%     hold on;
%     theta = this_feat(:,1);
%     rho = this_feat(:,2);
%     [X,Y] = pol2cart(theta,rho);
%     nnz = find(rho);    
%     if this_label            
%         scatter(X(nnz),Y(nnz),'o','MarkerEdgeColor','g');
%     else
%         scatter(X(nnz),Y(nnz),'o','MarkerEdgeColor','r');
%     end
    
     for jj=1:size(this_feat,1) % should be consistent
         y = this_feat(jj,:);
         x = [1:size(y,2)];
         subplot(2,4,jj);
         hold on;
         if y(1,1)~=0
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
end

        
    

    
    
