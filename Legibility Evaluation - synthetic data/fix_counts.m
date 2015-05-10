function fixed_counts = fix_counts(counts)
% "fixes" a count matrix so that any pair of comparisons
% with zero or N unanimous judgments are set to be
% .5 and N?.5 respectively,
% where N is the total number of judgments for the pair.
%
% counts is a count matrix where counts(i,j) is the
% number of times option i was preferred over option j.
%
% fixed counts(i,j) = 0.5, if counts(i,j) = 0 and i6=j
% N ? 0.5, if counts(i,j) = N and i6=j
% counts(i,j), otherwise
%
% 2011?06?05 Kristi Tsukida <kristi.tsukida@gmail.com>

N = counts+counts'; % Total number of comparisons for each pair
zero_counts = (counts == 0); % logical matrix: 1 if counts(i,j)=0
N_counts = zero_counts'; % logical matrix: 1 if counts(i,j)=N(i,j)

fixed_counts = counts;
fixed_counts(zero_counts) = 0.1;
fixed_counts(N_counts) = N(N_counts)-0.1;
fixed_counts(N==0) = 0; % If there were no comparisons, don't modify counts
fixed_counts(eye(size(counts))>0) = 0; % Set the diagonal to be zero
