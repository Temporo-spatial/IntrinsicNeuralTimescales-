function [PLEout] = PLE_JF_EEG_handle(EEG)

PLEout = zeros(1,30);

disp(' ')
disp('Computing power law exponent...')

for c = 1:EEG.nbchan
    fprintf([num2str(c) ' ']);
    PLEout(c) = JF_power_law(EEG.data(c,:),1/EEG.srate,0.5,30);
end

