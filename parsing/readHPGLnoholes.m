function [V,E] = readHPGLnoholes(hpgl_file_name)
% READHPGLCAGE Parses an HPGL file and returns a polyline as vertices C and
% edges E
% ASSUMES NO HOLES
% This file can be used to read cages and skeletons
% =========================================================================
hpgl_file_handle = fopen(hpgl_file_name);

E = [];
V = [];

while(true)
    % read next whole line
    line = fscanf(hpgl_file_handle,' %[^\n]s');
    [e,count] = sscanf(line,'%c %c %d %d',4);
    if(count==2||count==3)
    elseif(count==4)
        prefix = char([e(1) e(2)]);        
        if(strcmp(prefix,'PU'))            
            V = [V; e(3) e(4)];
        elseif(strcmp(prefix,'PD'))
            V = [V; e(3) e(4)];
            E = [E; V(end-1,:) V(end,:)];
        end       
    else
        break;
    end
end

fclose(hpgl_file_handle);

% Remove duplicate vertices
V = unique(V,'rows','stable');

% Re-construct Edges as indices into C
[Lia,E1_in_V] = ismember(E(:,1:2),V,'rows');
[Lia,E2_in_V] = ismember(E(:,3:4),V,'rows');
E = [E1_in_V E2_in_V];
    
end
    
    
