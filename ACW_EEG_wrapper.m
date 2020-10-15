function [ACWOut] = ACW_EEG_handle(EEG)

ACWOut = zeros(1,EEG.nbchan);

disp(' ')
disp('Computing autocorrelation window...')

for c = 1:EEG.nbchan
    fprintf([num2str(c) ' ']);
    ACWOut(c) = ACW_estimation(EEG.data(c,:),EEG.srate,20);
end