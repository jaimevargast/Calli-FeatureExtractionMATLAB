function C = cage_hpgl_2_C(hpgl_file_name)
% Saves pen-up positions of specially constructed HPGL file. These
% positions indicate the coordinates of control points ON THE BOUNDARY
% *************************************************************************
% NOTE:  This function is designed specifically for reading constructed
% ideal letters,
% ************************************************************************

hpgl_file_handle = fopen(hpgl_file_name);

C = [];
ix = 1;

% Parse HPGL file:
% -------------------------------------------------------------------------
% Store pen up positions (as indices into X and Y) in H
% -------------------------------------------------------------------------
% ASSUMES CLOSED BOUNDARIES AND UN-WELDED LINES
% -------------------------------------------------------------------------

while(true)
    % read next whole line
    line = fscanf(hpgl_file_handle,' %[^\n]s');
    [e,count] = sscanf(line,'%c %c %d %d',4);
    if(count==2||count==3)
    elseif(count==4)
        prefix = char([e(1) e(2)]);
        if(strcmp(prefix,'PU'))
            C= [C; e(3) e(4)];
        end        
    else
        break;
    end
end
    
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



