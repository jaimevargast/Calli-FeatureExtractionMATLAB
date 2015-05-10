function [S,P] = scale_ls_btl(counts)
% Use the least squares complete matrix solution to
% scale a paired comparison experiment using
% Bradley?Terry's logistic model
%
% counts is a n?by?n matrix where
% counts(i,j) = # people who prefer option i over option j
% S is a length n vector of scale values
%
% 2011?06?05 Kristi Tsukida <kristi.tsukida@gmail.com>

s = sqrt(3) / pi; % logistic distribution parameter
[m,mm] = size(counts);
assert(m == mm, 'counts must be a square matrix');

% Empirical probabilities
N = counts + counts';
P = counts ./ (N + (N==0)); % Avoid divide by zero
P(eye(m)>0) = 0.5; % Set diagonals to have probability 0.5
P(P==0) = 0.05;

Z = s * log(P ./(1-P)); % logit z?scores
S = -mean(Z,1)';
