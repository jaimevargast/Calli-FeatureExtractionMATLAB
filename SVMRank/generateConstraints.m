function [ A ] = generateConstraints( labels )
%GENERATECONSTRAINTS This function turns 'n' labels (legibility scores)
%into an 'nchoosek(n,2)' by 'n' matrix (number of pairs), in each row all the
%columns are zero except two which are -1,+1, showing in the corrosponding
%pair, which instance is preferred
% labels is a vector of size n

%   Detailed explanation goes here
no_instances = length(labels);
no_pairs = nchoosek(no_instances, 2);
A = zeros(no_pairs, no_instances);

counter = 1;
for i = 1:no_instances - 1
    for j = i+1:no_instances
        if labels(i) > labels(j)
            A(counter, i) = 1;
            A(counter, j) = -1;
        else
            A(counter, i) = -1;
            A(counter, j) = 1;
        end
        counter = counter + 1;
    end
end

A = sparse(A);

end

