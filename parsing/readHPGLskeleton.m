function [V,C,E] = readHPGLskeleton(hpgl_file_name)
% READEDGE read .hpgl file that contains polyline information
%
% [V,C] = readHPGL(hpgl_file_name)
%
% Input:
%   hpgl_file_name  input file name
%
% Output:
%   V  #V by 2 list of vertices
%   C  Connectivity

hpgl_file_handle = fopen(hpgl_file_name);

X = [];
Y = [];
%   E = [];
H = [];
C = [];
ix = 1;

while(true)
    % read next whole line
    line = fscanf(hpgl_file_handle,' %[^\n]s');
    [e,count] = sscanf(line,'%c %c %d %d',4);
    if(count==2||count==3)
    elseif(count==4)
        prefix = char([e(1) e(2)]);
        if(strcmp(prefix,'PU'))
            H = [H ix];
            C = [C; e(3) e(4)];
        end
        X = [X; e(3)];
        Y = [Y; e(4)];
        ix=ix+1;
    else
        break;
    end
end
%H = [H ix];
%C = [C; e(3) e(4)]; % because the very last point is also a pen up

fclose(hpgl_file_handle);

V = [X Y];
V = unique(V,'rows','stable');
E = [];

csvwrite(strcat(hpgl_file_name,'.csv'),V);

% Construct Edges 
% for i = 1:(numel(H)-1)
%     dum1 = [H(i):(H(i+1)-1)];
%     this_V = [X(dum1) Y(dum1)];    
%     [Lia,Locb] = ismember(this_V,V,'rows');
%     for j = 1:(size(Locb,1)-1)
%         E = [E; Locb(j) Locb(j+1)];
%     end    
% end


% for i = 1:numel(poly)
%     dum1 = [poly(i).x poly(i).y];
%     dum2 = circshift(dum1,[-1 0]); %duplicate and offset by -1 to compute distance between vertex pairs (segment length)
%     dist(i).pairwise = distancePoints(dum1,dum2,'diag');
%     dist(i).pairwise(end,:) = []; %drop last distance;
%     dist(i).tot_length = sum(dist(i).pairwise);
%     dist(i).rel_pairwise = dist(i).pairwise./dist(i).tot_length;
%     
%     % Find tiny segments
%     tix = dist(i).rel_pairwise<=(1/samplesize);
%     tinysegments = dist(i).rel_pairwise(tix);
%     
%     % Tiny segments can't be re-sampled further, so remove the number of
%     % tiny segments from desired sample size
%     segments_used = numel(tinysegments);
%     working_segments = samplesize - segments_used;
% 
%     dumx = [];
%     dumy = [];
%     if working_segments>1
%         for j = 1:numel(dist(i).pairwise)
%             if (dist(i).rel_pairwise(j) > (1/samplesize))
%                 num_points = floor(working_segments*dist(i).rel_pairwise(j));            
%                 segments_used = segments_used + num_points;
%                 if (j == numel(dist(i).pairwise))
%                     num_points = num_points + (samplesize-segments_used); % last segment; make sure I've used up all my segments
% 
%                     n_x = linspace(poly(i).x(j),poly(i).x(j+1),num_points)';
%                     n_y = linspace(poly(i).y(j),poly(i).y(j+1),num_points)';
% 
%                     dumx = [dumx; n_x];
%                     dumy = [dumy; n_y];                
% 
%                 else
%                     n_x = linspace(poly(i).x(j),poly(i).x(j+1),num_points+1)';
%                     n_y = linspace(poly(i).y(j),poly(i).y(j+1),num_points+1)';
% 
%                     n_x(end,:) = [];
%                     n_y(end,:) = [];
% 
%                     dumx = [dumx; n_x];
%                     dumy = [dumy; n_y];
%                 end            
%             else
%                 dumx = [dumx; poly(i).x(j+1)];
%                 dumy = [dumy; poly(i).y(j+1)];
%             end
%         end    
%         poly(i).x = dumx;
%         poly(i).y = dumy;
%     end
% end
    
end
    
    
%%%% SKELETON ONLY, NO HOLES!
% for i = 1:length(poly)
%     for j = 1:length(poly)
%         if ((i~=j)&&~(poly(j).hole))
%             if (inpolygon(poly(j).x(1),poly(j).y(1),poly(i).x,poly(i).y));
%                 poly(j).hole = 1;
%             end
%         end
%     end
% end

%upsample polylines
% for i = 1:numel(poly)
%     dummy = [poly(i).x poly(i).y];
%     dummy2 = resamplePolyline(dummy,samplesize);
%     poly(i).x = dummy2(:,1);
%     poly(i).y = dummy2(:,2);
% end



