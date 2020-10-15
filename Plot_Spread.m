
data = {HC_Open,nonLIS_Open,LIS_Open,CLIS2_Open}; 
 plotSpread(data,'distributionColors',{'r','b','m','k'},'distributionMarkers',{'d','d','d','d'}, 'xNames',{'...','...', '...','...'}, 'ylabel',{'...'}); 

 title('...')
set(gcf,'position',[10,10,450,400])
ylim([0 0.15]);
set(gca,'FontSize', 12)
set(gca,'LineWidth', 1)
