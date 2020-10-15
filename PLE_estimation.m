function PLE=PLE_estimation(PSD,f)
% PLECOMPUTATION
%
% Inputs:
%   - PSD: Power spectral density of the time series
%   - f:   Frequencies of the PSD (PSD and f must have the same length)
%
% Version: 1.0
% Date: September 25, 2017
% Author: Javier Gomez-Pilar, jgompil@gmail.com
%

[PLE_,~]=polyfit(log10(f),log10(PSD),1);

PLE=-1*(PLE_(1));








