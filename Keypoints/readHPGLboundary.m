function [poly,PolySegment] = readHPGLboundary(hpgl_file_name)
% Saves pen-up positions of specially constructed HPGL file. These
% positions indicate the coordinates of control points ON THE BOUNDARY
% *************************************************************************
% NOTE:  This function is designed specifically for reading constructed
% ideal letters,
% ************************************************************************

hpgl_file_handle = fopen(hpgl_file_name);

PolySegment = {};
V = [];

while(true)
    % read next whole line
    line = fscanf(hpgl_file_handle,' %[^\n]s');
    [e,count] = sscanf(line,'%c %c %d %d',4);
    if(count==2||count==3)
    elseif(count==4)
        prefix = char([e(1) e(2)]);
        if(strcmp(prefix,'PU'))
            if ~(isempty(V))
                PolySegment = [PolySegment V];
                V = [];
            end           
            V = [V; e(3) e(4)];            
        elseif(strcmp(prefix,'PD'))
            V = [V; e(3) e(4)];            
        end       
    else
        break;
    end
end
PolySegment = [PolySegment V];
fclose(hpgl_file_handle);


% Resample segments uniformly and construct polygon
poly = [];
l = 1;
for i = 1:size(PolySegment,2)
    poly_aux = resamplePolyline(cell2mat(PolySegment(1,i)),100);
    PolySegment(1,i) = {[l:l+99]'};
    l = l+99;    
    poly = [poly; poly_aux];
end

adj = cell2mat(PolySegment(end));
adj(end) = 1;
PolySegment(end) = {adj};

% remove duplicate vertices
poly = unique(poly,'rows','stable');
end
    
    
