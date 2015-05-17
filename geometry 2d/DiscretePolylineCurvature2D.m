function K = DiscretePolylineCurvature2D(Vertices)
%Construct line segments
P1 = Vertices;
P2 = circshift(P1,[-1 0]);
P3 = circshift(P2,[-1 0]);
P1((end-1):end,:) = [];
P2((end-1):end,:) = [];
P3((end-1):end,:) = [];
     
%COMPUTE TURNING ANGLES
theta = angle3Points(P1,P2,P3);
theta = pi-theta;
 
%COMPUTE CURVATURE
K = (sin(theta./2)).*2;
%tempK = abs(k);
%     ix = find(tempK<0.00001);
%     k(ix) = 0;
%     K = [K; k'];
%     
end
