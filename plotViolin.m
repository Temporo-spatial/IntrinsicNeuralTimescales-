function plotViolin(features,options)
%   
%   plotViolin(features,options) plots the distribution of a matrix of
%   features. Each column of the matrix is a feature.
%
%   Input parameters:
%       - features: matrix of features. Each column is a feature, whereas
%                   each row is an instance (subject).
%       - options:  struct that contains the customized params.
%             * options.Xlabels:      Labels of the x axis (groups)
%             * options.Ylabel:       Label of the y axiz (feature)         
%             * options.Colors:       Colors of the boxplots (one per group/column)         
%             * options.PlotSize:     Size of the figure
%
%   -------------------------------------------------------------------------------
%   Example of use:
%
%   features=rand(100,2);
%   options.Xlabels={'group #1','group #2'};
%   options.Ylabel={'myFeature'};
%   options.Colors=[0.3 0.5 0.5;0.8 0.1 0.1];
%   options.PlotSize=[400 500];
%
%   -------------------------------------------------------------------------------
%   Version: 1.0
%   Date: February 11, 2019
%   Author: Javier Gomez-Pilar, jgompil@gmail.com
%


 load('...')

  features = (RS_Task_all);
%  [m,n]=size(features);
%   
%    for i=1:n
%        name= input('insert group name: ','s');
%        group(i,:)=(name);
%        colors(i,:)=(name); 
%        colors(i,:)=[rand(1,1) rand(1,1) rand(1,1)];
%    end
   
   options.Xlabels= {'...' '...' '...' '...'}; 
   options.Ylabel={'PLE'};
   options.Colors= [];  
   options.PlotSize=[600 600];
   
  

% My figure
h_figure=figure('position',[700 100 options.PlotSize]);
h_distribution=distributionPlot(features,'xnames',options.Xlabels,'addBoxes',0,'histOpt',1,'colormap',[.3 .3 .3],'showMM',0,'variableWidth',1,'addSpread',0,'invert',0,'xyOri','normal');
ylimits=h_distribution{3}.YAxis.Limits;
 ylimits=([0 2]); %[0 0.12]);
 ytickformat('%.2f')

hold on
boxplot(features,'Labels',options.Xlabels);
bh = findobj(gca,'Tag','Box');

%%% Layout
ylim(ylimits)
ylabel(options.Ylabel)
box off 
set(gca,'FontSize', 18)
set(gca,'LineWidth', 2)
set(gca,'Color','none')
set(gcf,'position',[10,10,950,750])
set(gca,'yTick',0:0.2:2); 
for j=1:length(bh)
    patch(get(bh(j),'XData'),get(bh(j),'YData'),options.Colors(j,:),'FaceAlpha',.5);
end








