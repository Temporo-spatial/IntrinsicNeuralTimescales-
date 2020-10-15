function myTopoplot(vector)

load ('...')
% 'vector' variable is vector of 257 elements (number of channel) with the
% values of the PLE, ACW or whatever

% Use the locs depending on your data
    load ('...')

 topoplot(vector,ChannelLocs,'maplimits',[0 1]) 
%        colorbar
title('...')
set(gcf,'units','points','position',[10,10,500,500])
set(gca,'FontSize', 26)