function [chull,bays] = extractConcavities(polygon)
    
    bays = {};
    
    K = convhull(polygon,'simplify',false);
    
    chull = polygon(K,:);
    
    dummy = [1:size(polygon,1)].';
    
    [bay_indices,ps] = removerows(dummy,'ind',K);
    
    count = 1;
    x = [];
    y = [];
    
    if (bay_indices(1)~=1)
        pre=bay_indices(1)-1;
    else
        pre = size(polygon,1);
    end
    
    x = [x; polygon(pre,1)];
    y = [y; polygon(pre,2)];
    
    for i = 1:(length(bay_indices)-1)        
       
        x = [x; polygon(bay_indices(i),1)];
        y = [y; polygon(bay_indices(i),2)];    
        
        if (abs(bay_indices(i+1)-bay_indices(i))~=1)
            
            if (bay_indices(i)~=size(polygon,1))
                post=bay_indices(i)+1;
            else
                post= 1;
            end
            
            x = [x; polygon(post,1)];
            y = [y; polygon(post,2)];
            
            bays(count).x = x;
            bays(count).y = y;
            count = count + 1;
            x = [];
            y = [];
            
            if (bay_indices(i+1)~=1)
                pre=bay_indices(i+1)-1;
            else
                pre = size(polygon,1);
            end
            
            x = [x; polygon(pre,1)];
            y = [y; polygon(pre,2)];           
        end
        
        if (i == length(bay_indices)-1)
            
            x = [x; polygon(bay_indices(i+1),1)];
            y = [y; polygon(bay_indices(i+1),2)];
            
            if (bay_indices(i+1)~=size(polygon,1))
                post=bay_indices(i+1)+1;
            else
                post= 1;
            end
            
            x = [x; polygon(post,1)];
            y = [y; polygon(post,2)];           
            
            bays(count).x = x;
            bays(count).y = y;
            count = count + 1;
            x = [];
            y = [];
        end            
    end
    
end