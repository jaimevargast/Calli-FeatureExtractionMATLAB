function context = fullShapeContext(polygon)

polygon = scalePolyConstrained(polygon);

if isPolygonCCW(polygon)
    polygon = reversePolygon(polygon);
end


NR = 5; %number of rings
NW = 12; %number of wedges
RMIN = 0.03;
RMAX = 2;
mean_dist_global=[];



nsamp = size(polygon,1);
    
out_vec = zeros(1,nsamp);
    
[context,mean_dist] = sc_compute(polygon',zeros(1,nsamp),mean_dist_global,NW,NR,RMIN,RMAX,out_vec); 
     


end