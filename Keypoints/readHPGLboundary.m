function [poly] = readHPGLboundary(hpgl_file_name)
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

% Hacky resampling to match original mesh used for "S"
poly = [];

%top side = 7 points
poly_aux = cell2mat(PolySegment(1));
poly = [poly; resamplePolyline(poly_aux,7)];

%right side = 13 points
poly_aux = cell2mat(PolySegment(2));
poly = [poly; resamplePolyline(poly_aux,13)];

%bottom side = 7 points
poly_aux = cell2mat(PolySegment(3));
poly = [poly; resamplePolyline(poly_aux,7)];

%left side = 65 points
poly_aux = cell2mat(PolySegment(4));
poly = [poly; resamplePolyline(poly_aux,65)];

% remove duplicate vertices
poly = unique(poly,'rows','stable');
end
    
    
