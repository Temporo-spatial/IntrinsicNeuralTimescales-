function [ACW] = ACW_estimation(EEG,fs,window,overlap,lag)
% AWC The function estimates the width of the mean lobe of the
% autocorrelation. It is defined as the full-width-at-half-maximum of the
% temporal autocorrelation function of the power time course.
%
%   Input: 
%       -EEG:       time course of the EEG in a single channel
%       -FS:        sample frequency or sample rate(in Hz)
%       -WINDOW:    size (in seconds) of the windows or block to compute
%                   the AC function. Zero means that the block is all the
%                   time serie. Zero is the default.
%       -OVERLAP:   % of overlaping. 50% by default.
%       -LAG:       limits the lag range from –lag to lag (in seconds). lag
%                   defaults to (N–1)/fs.
%   Output:
%       -ACW_ESTIMATION: Estimation of the width of the main lobe of the
%                        ACW. It is measured as de the 
%                        full-width-at-half-maximum of the temporal
%                        autocorrelation function of the power time course.
%
% IMPORTANT NOTE:
% To calculate ACW in the same way as Honey et al. 2012, each power time
% courses must be decomposed into 20 s blocks with 10 s of overlap (50% of
% overlap).
% REF: Honey, Christopher J., et al. "Slow cortical dynamics and the
% accumulation of information over long timescales." Neuron 76.2 (2012):
% 423-434.
%
% Version: 1.0
%
% Date: September 12, 2017
% Last update: September 12, 2017
%
% Javier Gomez-Pilar | jgompil@gmail.com
%

%% Set initial defaults (user-specified)
if nargin<3 || isempty(window),
    error('Not enough input arguments.');
end
if nargin<4 || isempty(overlap),
    overlap=50;
end
if nargin<5 || isempty(lag),
    lag=(length(EEG)-1)/fs;
end


% Time to samples
window=window*fs;
lag=lag*fs;


% Sliding window for computing autocorrelation function (ACF)
ii=1;   % Windows counter
while true
    % Begining and ending of the current window
    SWindow=[1+(ii-1)*window*overlap/100, window+(ii-1)*window*overlap/100];
    % Chek if index exceeds vector dimensions. If so, break!
    if SWindow(2)>=length(EEG), break; end
    % ACF computation into the window (normalized between -1 and 1)
    ACF(ii,:)=xcorr(EEG(SWindow(1):SWindow(2)),lag,'unbiased');
    % Next window
    ii=ii+1;
end
figure
plot(ACF')
% As in Honey et al. 2012, ACF is averaged
ACF_mean=mean(ACF,1);
% Look for the index where the mean of the ACF is maximum
[~,index]=max(ACF_mean);
% Number of indices over the half in the rigth side of the lobe
my_index=ACF_mean>=0.5;
myindex=my_index(index:end);
under_half=find(myindex==0);
first_under_half=under_half(1);

ACW_samples=2*(first_under_half-1)-1;   % ACW in samples
ACW=ACW_samples/fs;                     % ACW in time

% Only to check
figure
time=linspace(-lag/fs,lag/fs,2*lag+1);
plot(time,ACF_mean)
xlabel('ACF')
ylabel('Time (seconds)')
hold on
h=fill(time,ACF_mean>=max(ACF_mean)/2,'r');
set(h, 'FaceAlpha',.3);
% hold off



