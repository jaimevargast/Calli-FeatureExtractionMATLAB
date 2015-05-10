function [ cc ] = polyChainCode(P1,P2)

cc = [];
A = angle2Points(P1,P2);


%   used direction-to-code convention is:       3  2  1
%                                                \ | /
%                                             4 -- P -- 0
%                                                / | \
%                                               5  6  7

for i = 1:length(A)
    if      (A(i)>=(15*pi/8) &&  A(i)<=(2*pi)) || (A(i)>=0 && A(i)<(pi/8))
        cc = [cc; 0];
    elseif  A(i)>=(pi/8)    &&  A(i)<(3*pi/8)
        cc = [cc; 1];
    elseif  A(i)>=(3*pi/8)  &&  A(i)<(5*pi/8)
        cc = [cc; 2];
    elseif  A(i)>=(5*pi/8)  &&  A(i)<(7*pi/8)
        cc = [cc; 3];
    elseif  A(i)>=(7*pi/8)  &&  A(i)<(9*pi/8)
        cc = [cc; 4];
    elseif  A(i)>=(9*pi/8)  &&  A(i)<(11*pi/8)
        cc = [cc; 5];
    elseif  A(i)>=(11*pi/8) &&  A(i)<(13*pi/8)
        cc = [cc; 6];
    elseif  A(i)>=(13*pi/8) &&  A(i)<(15*pi/8)
        cc = [cc; 7];
    end
end



end

