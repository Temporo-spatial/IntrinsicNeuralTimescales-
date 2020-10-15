directory_name = uigetdir;
cd(directory_name);
eeglab
%%%%Let's select the relevant files,
files = dir(fullfile(directory_name, '*.edf'));

fileindex = find(~[files.isdir]);

%%%%Loop through all the files
for i = 1:length(fileindex)

	filename = files(fileindex(i)).name;
	[PATH, NAME, EXT] = fileparts(filename);

	NAME = [NAME, EXT];

    %load the data set
    EEG = pop_biosig([directory_name '\' filename], 'importevent','off');
    
    EEG = eeg_checkset( EEG );
     
    EEG = pop_saveset( EEG, 'filename',[filename, '.set'],'filepath',directory_name); 

    EEG = eeg_checkset( EEG );
    
    % import channel locations
    EEG=pop_chanedit(EEG, 'lookup','...');
    
    
    if isempty(EEG.chanlocs(1).theta)
        for c = 1:length(EEG.chanlocs)
            tmp = extractBetween(EEG.chanlocs(c).labels,'EEG ','-');
            if ~isempty(tmp)
                EEG.chanlocs(c).labels = tmp{1};
            end
        end
        EEG=pop_chanedit(EEG,'lookup', '...');
        emptychannels = [];
        
        for c = 1:length(EEG.chanlocs)
            if isempty(EEG.chanlocs(c).theta)
                emptychannels = [emptychannels c];
            end
        end
        
        EEG.chanlocs(emptychannels) = [];
        EEG.data(emptychannels,:) = [];
        EEG = eeg_checkset(EEG);
    end
    
    % save file 
	%EEG = pop_saveset( EEG, 'filename',[filename, '.set'],'filepath',directory_name); 

%     % remove nonused EKG channels
    EEG = pop_select(EEG, 'nochannel', {'EKG', 'VEO', 'HEO'}); 

    % Downsample to 250Hz
    EEG = pop_resample( EEG, 250);
    
    % High pass filter at 0.5Hz
    EEG = pop_eegfiltnew(EEG, [], 0.5, 1650, true, [], 0);
    
    % Low pass filter at 50Hz
    EEG = pop_eegfiltnew(EEG, [], 50, 66, 0, [], 0);
    
    % Keep original EEG as will need channels from here to interpolate
    % after run clean_rawdata
    originalEEG = EEG;
    
    % Run clean_rawdata which will get rid of flat or noisy channels and
    % get rid of blinks, etc in continuous data
    EEG = clean_rawdata(EEG, 5, [-1], 0.8, -1, 5, 0.5);
    
    % Now interpolate the channels that were deleted in the previous step:
    EEG = pop_interp(EEG, originalEEG.chanlocs, 'spherical');
      
    % Reference electrodes to average:
    EEG = pop_reref( EEG, []);
        
    % Finally, save the new file that has been cleaned:
	EEG = pop_saveset( EEG, 'filename',[filename, '_worked.set'],'filepath',[directory_name '\Worked']); 

end;