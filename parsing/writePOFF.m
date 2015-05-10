% % BOUNDARY TO POFF
% =========================================================================
%     INPUT =
%         B = N-by-1 cell where N is genus of original shape, and where
%         each cell is an array containing the ij-positions of the boundary
%         saveas = path of .poff file to be saved
%     
%     OUTPUTS = 
%         .poff file with normalized x,y coordinates of points along boundaries
% =========================================================================

function writePOFF(X,Y,saveas)

%     % merge all outlines
%     boundary = [];
%     boundary = cat(1,boundary,B{:});
%     
%     % set scaling factor
%     scale = max(max(boundary));
%     
%     %normalize
%     boundary = boundary./scale;
% 
%     % convert from rows,cols to x,y
%     rows_to_y = 1 - boundary(:,1);
%     boundary(:,1) = boundary(:,2);
%     boundary(:,2) = rows_to_y;

    % open a file for writing
    fid = fopen(saveas, 'w');
    coords = [X Y];

    % print a header
    fprintf(fid, sprintf('POFF %d 0 0\n',size(X,1)));

    % print values
    fprintf(fid,'%d %d\n',coords');
    fclose(fid);
end