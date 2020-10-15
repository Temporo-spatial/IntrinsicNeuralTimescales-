directory_name = uigetdir;
cd(directory_name);
eeglab
%%%%Let's select the relevant files,
files = dir(fullfile(directory_name, '*.set'));


% EEG = pop_mffimport('fileindex');
%EEG = pop_readegimff ('EEG', 'auto', 'files');
  %EEG = pop_mffimport('filename', {'classid'});

fileindex = find(~[files.isdir]);


%%%%Loop through all the files
for i = 1:length(fileindex)
    
    filename = files(fileindex(i)).name;
	[PATH, NAME, EXT] = fileparts(filename);

	NAME = [NAME, EXT];

    %load the data set
    EEG = pop_loadset( 'filename', filename, 'filepath', directory_name);

EEG.data=EEG.data';

% Load the filter
load('FIRFilter_order1000_notch59.8-60.2_Hamming_fs250hz.mat') %('FIRFilter_order1000_notch59.8-60.2_Hamming.mat')

% Apply the filter to your signal
EEG.data=filtfilt(Num,Den,double(EEG.data));   
% YOUR_EEG must be a matriz where the rows are the samples and the columns are the channel. IE: size(YOR_EEG) must be 75001 x channels

EEG.data=EEG.data';

% Finally, save the new file that has been cleaned:
	EEG = pop_saveset( EEG, 'filename',[filename, '_filt.set'],'filepath',[directory_name '\filt']); 

end;