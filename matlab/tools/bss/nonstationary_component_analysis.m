function [y, W, A, B, C] = nonstationary_component_analysis(x, I, J)
% nonstationary_component_analysis - Nonstationary Component Analysis (NSCA)
%   algorithm to extract temporal nonstationarities from multichannel data
%
% Usage:
%   [y, W, A, B, C] = nonstationary_component_analysis(x, I, J)
%
% Inputs:
%   x: Mixture of signals, where each row represents a different signal (N x T).
%   I: Desired time window indices (in 1:T).
%   J: Desired time window indices (in 1:T).
%
% Outputs:
%   y: Separated components of the input signals (N x T).
%   W: Separation filters.
%   A: Inverse of separation filters.
%   B: Covariance matrix computed from time window I.
%   C: Covariance matrix computed from time window J.
%
% Note: The time window indices I and J specify subsets of the input signals
% for performing generalized eigenvalue decomposition.
%
% Example usage:
%   x = ... % Define the mixture of signals
%   I = ... % Define the time window indices for covariance matrix B
%   J = ... % Define the time window indices for covariance matrix C
%   [y, W, A, B, C] = nsca_source_separation(x, I, J);
%
% References:
% - Sameni, R., Jutten, C., and Shamsollahi, M. B. (2010). A Deflation 
%   Procedure for Subspace Decomposition. In IEEE Transactions on Signal Processing
%   (Vol. 58, Issue 4, pp. 2363–2374). doi: 10.1109/tsp.2009.2037353
% - Sameni, R., and Gouy-Pailler, C. (2014). An iterative subspace denoising algorithm 
%   for removing electroencephalogram ocular artifacts. In Journal of Neuroscience Methods
%   (Vol. 225, pp. 97–105). doi: 10.1016/j.jneumeth.2014.01.024
%
% Revision History:
%   2014: First release
%   2023: Renamed from deprecated version NSCA()
%
% Reza Sameni, 2014-2023
% The Open-Source Electrophysiological Toolbox
% https://github.com/alphanumericslab/OSET

% Compute covariance matrices for the desired time windows
B = cov(x(:, I)');
C = cov(x(:, J)');

% Symmetrize the covariance matrices
C = (C + C') / 2;
B = (B + B') / 2;

% Perform eigenvalue decomposition using Cholesky decomposition
[V, D] = eig(B, C, 'chol');

% Sort eigenvalues in descending order
[~, II] = sort(diag(D), 'descend');

% Extract separation filters
W = V(:, II)';
A = pinv(W);

% Apply separation filters to input signals
y = real(W * x);