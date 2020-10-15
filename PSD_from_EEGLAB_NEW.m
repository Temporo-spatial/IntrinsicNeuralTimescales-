%%% PATH CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include here the folder's path of your original data (.set and .fdt)    %
files_path_set='...';  % windows path     %
% Include here the folder's path of your new data (.mat)                  % 
files_path_mat='...';  % windows path     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Get names
files=dir([files_path_set '*.set']);

% Export to .mat
for nfile=1:size(files,1)
    fprintf('....................Exporting from .set to .mat. Subject %i/%i\n',nfile,size(files,1))
    
    % Import data from EEGLAB format
    MySignal=pop_loadset([files_path_set '/' files(nfile).name]);
    % Save data to .mat format
    pop_export(MySignal,[files_path_mat files(nfile).name(1:end-4) '.mat'],'transpose','on','elec','off','time','off');
end

% Main loop
for nfile=1:size(files,1)
    fprintf('....................Processing subject %i/%i\n',nfile,size(files,1))
    
    % Load data
    Signal=load([files_path_mat '/' files(nfile).name(1:end-4) '.mat'],'-ascii');
    
    % PSD using Welch method
    %%% window of 3 seconds (your signal is 30 seconds long, so 10 windows)
    window=3;   % seconds
    overlap=[]; % [] is equal of 50% by default
    nfft=2^15;  % points of each PSD (the higher the nttf, the higher the frequency resolution, but higher noise/variability)
    [SIGNAL,f]=pwelch(Signal,hamming(window*MySignal.srate),overlap,nfft,MySignal.srate);
    
    % Normalization
    SIGNAL=SIGNAL./sum(SIGNAL,1);
    
    % PSD (grand-average: 1 PSD per subject)
    PSD(nfile,:)=nanmean(SIGNAL,2);
end

% Average across subjects (you must repeat this depending on your groups)
PSD_average=nanmean(PSD,1);


% Representation
%%% PSD
h_figure=figure('position',[700 100 600 400]);
%  plot(f,PSD)
h_plot=plot(log10(f),log10(PSD_average/sum(PSD_average)),'color',[.85 .15 .15],'linewidth',2); %
hold on
xlim([0 log10(40)]);        % From 0 to 40 Hz (you can change it). I put 40 Hz beacuse I see a filtering at 40 Hz in your signal
grid on
%%% Regression
max_freq_to_represent=40;
p1=polyfit(log10(f(2:find(f>40,max_freq_to_represent,'first'))),log10(PSD_average(2:find(f>40,max_freq_to_represent,'first'))'), 1);
plot(log10(f),polyval(p1,log10(f)),'--','color',[.85 .15 .15],'linewidth',1.5)


%%% Appearance
set(gca,'xtick',[0 log10(10) log10(20) log10(30) log10(40)])
set(gca,'xticklabel',[0 10 20 30 40])
xlabel('Frequency (Hz)')
ylabel('log({\itPSD})')
set(gca,'FontSize', 14)
set(gca,'LineWidth', 2)
set(gca,'Color','none')