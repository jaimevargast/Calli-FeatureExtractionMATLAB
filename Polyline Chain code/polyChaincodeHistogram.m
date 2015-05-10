function cc_hist = polyChaincodeHistogram(polygon,visualize);

    %Ensure counterclockwise
    if ~isPolygonCCW(polygon)
        polygon = reversePolygon(polygon);
    end
    
    polygon = scalePolyConstrained(polygon);
    len = polygonLength(polygon);

    numPoints = floor(len/.0025); %considering 800x800 resolution    
    %numPoints = 100;
    polygon = resamplePolygon(polygon,numPoints);

    polygon = scalePolyConstrained(polygon); %in case sampling moves some point beyond range

   P1 = polygon;
   P2 = circshift(polygon,[-1 0]);

   % construct grid
   gxx = linspace(-1,1,5)';
   gyy = linspace(1,-1,5)';
   
   % Visualize
   % ----------------------------------------------------------------------
   if(visualize)       
    figure;
    subplot(8,4,[17:32]);
    axis ([-1 1 -1 1]);
    hold on;
    for i = 1:numel(gxx)
        ray = createRay([gxx(i) gyy(1)],[gxx(i) gyy(2)]);
        ray2 = createRay([gxx(1) gyy(i)],[gxx(2) gyy(i)]);
        drawRay(ray);
        drawRay(ray2);
    end
   end
   % ----------------------------------------------------------------------
        
    
    

    grid_cell = cell(4,4);

    bin_edges = [-0.5 0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5];
    
    cols = ['y' 'm' 'c' 'r' 'g' 'b' 'k' 'y' 'm' 'c' 'r' 'g'];

    for ix = 1:size(gxx,1)-1
    
        % Construct strips
        if ix~=size(gxx,1)-1
            strip = find( P1(:,1)>=gxx(ix) & P1(:,1)<gxx(ix+1) );
        else
            strip = find( P1(:,1)>=gxx(ix) & P1(:,1)<=gxx(ix+1) );
        end
              
        strip_P1 = P1(strip,:);
        strip_P2 = P2(strip,:);
        
        % ----------------------------------------------------------------------
        if (visualize)
            subplot(8,4,[17:32]);
        for s = 1:size(strip_P1,1)
            drawPolyline([strip_P1(s,:); strip_P2(s,:)]);
        end
        end
        % ----------------------------------------------------------------------
                    
        % Construct cells
        for iy = 1:size(gyy,1)-1
            
            if iy~=size(gxx,1)-1
                section = find( strip_P1(:,2)<=gyy(iy) & strip_P1(:,2)>gyy(iy+1) );
            else
                section = find( strip_P1(:,2)<=gyy(iy) & strip_P1(:,2)>=gyy(iy+1));
            end
            
            cell_P1 = strip_P1(section,:);
            cell_P2 = strip_P2(section,:);
            
            % ----------------------------------------------------------------------
            if (visualize)
                subplot(8,4,[17:32]);
                scatter(cell_P1(:,1),cell_P1(:,2),'o','MarkerFaceColor',cols(ix+iy));
            end
            % ----------------------------------------------------------------------
            
            
            % get chaincode
            cc = polyChainCode(cell_P1,cell_P2);           

            % extract histogram
            if ~isempty(cc)
                out = [];
                aux = find(cc==0);
                out = [out; size(aux,1)];
                aux = find(cc==1);
                out = [out; size(aux,1)];
                aux = find(cc==2);
                out = [out; size(aux,1)];
                aux = find(cc==3);
                out = [out; size(aux,1)];
                aux = find(cc==4);
                out = [out; size(aux,1)];
                aux = find(cc==5);
                out = [out; size(aux,1)];
                aux = find(cc==6);
                out = [out; size(aux,1)];
                aux = find(cc==7);
                out = [out; size(aux,1)];
%                 out = histc(cc(:),bin_edges);
%                 if~iscolumn(out) % for some reason histc function sometimes returns output as row vector
%                     out = out';
%                 end
                grid_cell{iy,ix} = out;
            else
                grid_cell{iy,ix} = [0;0;0;0;0;0;0;0];
            end
            
            % ----------------------------------------------------------------------
            if (visualize)
                li = sub2ind([4 4],ix,iy);
                subplot(8,4,li);
                h = grid_cell{iy,ix};
                bar(h);
            end
            % ----------------------------------------------------------------------
                
        end
    end
    
    cc_hist = [];
    for i=1:size(grid_cell,1)
        for j=1:size(grid_cell,2)
            cc_hist = [cc_hist cell2mat(grid_cell(i,j))'];
        end
    end   
end
        
