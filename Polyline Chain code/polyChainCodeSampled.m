function [ cc_sampled ] = polyChainCodeSampled( polygon, no_samples )
%POLYCHAINCODESAMPLED Summary of this function goes here
%   Detailed explanation goes here

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
   
   cc = polyChainCode(P1,P2); 
   
   % sampling
   sampling_step = floor(length(cc) / no_samples);
   cc_sampled = cc(sampling_step: sampling_step: sampling_step * no_samples);
 
end

