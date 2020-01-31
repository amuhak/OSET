function y = TanhSaturation(x, ksigma)
% Saturates outlier samples using a tanh shape function
% For matrix data in the form of channels x time, the data is saturated over the second
% dimention (time)
%
% Open Source ECG Toolbox, version 3.14, Jan 2020
% Reza Sameni
% Jan 2020

sd = std(x, [], 2);
alpha = ksigma * sd;
T = size(x, 2);
y = alpha(:, ones(1, T)).*tanh(x./alpha(:, ones(1, T)));