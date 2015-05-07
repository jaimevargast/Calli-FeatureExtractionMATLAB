function cc_hist = polyChaincodeHistogram(polygon);

    polygon = scalePolyConstrained(polygon);
    len = polygonLength(polygon);

    numPoints = floor(len/.0025); %considering 800x800 resolution
    polygon = resamplePolygon(polygon,numPoints);

    polygon = scalePolyConstrained(polygon); %in case sampling moves some point beyond range

    drawPolygon(polygon,'Marker','.');
    axis ([-1 1 -1 1]);
    hold on;

    P1 = polygon;
    P2 = circshift(polygon,[-1 0]);

    % construct grid
    gxx = linspace(-1,1,5)';
    gyy = linspace(1,-1,5)';
    
    for i = 1:numel(gxx)
        ray = createRay([gxx(i) gyy(1)],[gxx(i) gyy(2)]);
        ray2 = createRay([gxx(1) gyy(i)],[gxx(2) gyy(i)]);
        drawRay(ray);
        drawRay(ray2);
    end
        
    
    

    grid_cell = cell(4,4);

    bin_edges = [-0.5 0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5];


    for ix = 1:size(gxx,1)-1
    
        % Construct strips
        if ix~=size(gxx,1)-1
            strip = find( P1(:,1)>=gxx(ix) & P1(:,1)<gxx(ix+1) );
        else
            strip = find( P1(:,1)>=gxx(ix) & P1(:,1)<=gxx(ix+1) );
        end
    
        % Construct cells
        for iy = 1:size(gyy,1)-1
            
            if iy~=size(gxx,1)-1
                section = find( P1(strip,2)<=gyy(iy) & P1(strip,2)>gyy(iy+1) );
            else
                section = find( P1(strip,2)<=gyy(iy) & P1(strip,2)>=gyy(iy+1) );
            end

            % get chaincode
            cc = polyChainCode(P1(section,:),P2(section,:));

            % extract histogram
            if ~isempty(cc)
                out = histc(cc(:),bin_edges);
                grid_cell{iy,ix} = out;
            else
                grid_cell{iy,ix} = [0,0,0,0,0,0,0,0];
            end          
        end
    end
    
    cc_hist = [];
    for i=1:numel(grid_cell)
        cc_hist = [cc_hist grid_cell{i}];
    end   
end
        
