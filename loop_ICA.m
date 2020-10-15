%loop for running ICA on the already preprocessed resting state files

eeglab
directory_name = uigetdir;
cd(directory_name);

files = dir(fullfile(directory_name, '*.set'));

fileindex = find(~[files.isdir]);

%%%%Loop through all the files
for i = 1:length(fileindex)

	filename = files(fileindex(i)).name;
	[PATH, NAME, EXT] = fileparts(filename);

	NAME = [NAME, EXT];

	EEG = pop_loadset( 'filename', filename, 'filepath', directory_name);
    
    % Downsample to 250Hz
%     EEG = pop_resample(EEG, 250);
    
    EEG = pop_runica(EEG, 'interupt','on');
	EEG = eeg_checkset( EEG );
	EEG = pop_saveset( EEG, 'filename',[filename, '_ICA.set'],'filepath',[directory_name '/ICA']); 
	EEG = eeg_checkset( EEG );
    
end;










