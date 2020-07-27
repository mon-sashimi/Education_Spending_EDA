function [fig,h] = showStateSpendingClusters(geoDataMerged,varargin)
%SHOWSTATESPENDINGCLUSTERS Use PCA to show clustered spatial spending
%
%  [fig,h] = gfx__.showStateSpendingClusters(geoDataMerged);
%  [...] = gfx__.showStateSpendingClusters(__,'Name',value,...);
%
% Inputs
%  geoDataMerged - Result of p__.mergeGeoSpendingData(geoData,T)
%  varargin - Optional 'Name',value parameter pairs
%        -> 'PC_Index' : 1 (def) | [1,2,3,4,5] Index of PC to show weights
%
% Output
%  fig             - Figure handle
%  h               - Group graphics object with child State objects as
%                       array of graphics Patch handles.
%
% See also: gfx__, index.mlx

% Parse optional input argument pairs %
pars = struct;
pars.Axes = [];
pars.Figure = [];
pars.PC_Index = 1;
pars.Legend = 'on';
pars.LegendIndices = [1 7];
pars.LegendLocation = 'southwest';
pars.ColorBar = 'off';
pars.ColorBarLocation = 'east';
pars.ColorMap   = flipud(jet(64));
pars.ColorRange = [1 64];
pars.TitleText = "";
pars.RemoveMean = true;
fn = fieldnames(pars);
if numel(varargin) > 0
   if isstruct(varargin{1})
      pars = varargin{1};
      varargin(1) = [];
   end
end

for iV = 1:2:numel(varargin)
   idx = strcmpi(fn,varargin{iV});
   if sum(idx)==1
      pars.(fn{idx}) = varargin{iV+1};
   end
end
% End argument pair parsing %

X = geoDataMerged.Spending; % Get spending array

% First, subtract the mean trend
if pars.RemoveMean
   X = (X - mean(X,1))';
else
   X = X';
end
[coeff,score,~,~,explained] = pca(X);

fig = figure('Name','PCA: Geospatial Education Spending',...
   'Color','w','Units','Normalized','Position',[0.35 0.50 0.60 0.40]);
ax = gobjects(3,1);
% First, show the percentage of the data shown by each component. A
% component that captures a tiny part of the data may have some interesting
% trend to it, but it's really not that interesting overall since it isn't
% a "strongly-present" feature of the data.
ax(1) = subplot(2,2,1);
set(ax(1),'XColor','k','YColor','k','NextPlot','add','FontName','Arial');
line(ax(1),0:numel(explained),[0;cumsum(explained)],...
   'LineWidth',2,'Color','k',...
   'DisplayName','Cumulative Data Explained',...
   'MarkerIndices',pars.PC_Index+1,...
   'Marker','s','MarkerSize',12,'MarkerFaceColor',[1 0.5 0.5]);
line(ax(1),[0 24],ones(1,2).*sum(explained(1:pars.PC_Index)),...
   'LineStyle','--','Color','m','LineWidth',2,'DisplayName',...
   'Total Data Explained by PCs Below');
title(ax(1),'% Data Explained','FontName','Arial','Color','k');
xlabel(ax(1),'Component','FontName','Arial','Color','k');
legend(ax(1),'Location','southeast','FontName','Arial','TextColor','black');

% Next, plot the different components of spending trends by state and
% highlight the one that is being shown on the geospatial activations
ax(2) = subplot(2,2,3);
co = repmat(rand(5,1)*0.15,1,3); % Allow for slight variation in grey colors
if pars.PC_Index > 1
   co(1:(pars.PC_Index-1),:) = [1 0 1] - co(1:(pars.PC_Index-1),:); % Make the ones up to this version be magenta
   co = max(co,0);
end
co(5,:) = [1 0.5 0.5];

set(ax(2),'XColor','k','YColor','k','NextPlot','add','FontName','Arial',...
   'ColorOrder',co);
vec = 1:5;
iOther = vec~=pars.PC_Index;
labs = {'PC-1';'PC-2';'PC-3';'PC-4';'PC-5'};
hTrends = plot(geoDataMerged.Properties.UserData.t,...
   score(:,vec(iOther)),...
   'LineWidth',2.5,'Marker','none');
set(hTrends,{'DisplayName'},labs(iOther));
line(geoDataMerged.Properties.UserData.t,...
   score(:,pars.PC_Index),....
   'LineWidth',3.5,'Marker','o','Color',[1 0.5 0.5],...
   'MarkerSize',4,'MarkerFaceColor','k',...
   'DisplayName',sprintf('PC-%d (shown)',pars.PC_Index));
xlabel(ax(2),'Year','Color','k','FontName','Arial');
ylabel(ax(2),'PC Score','Color','k','FontName','Arial');
legend(ax(2),...
   'TextColor','black',...
   'Color','none',...
   'Location','northwest',...
   'FontName','Arial');
xlim(ax(2),[1986,2016]);
set(ax(2),'XTick',1992:4:2016);

% Last, update the 'IndexedValue' variable of geoDataSpending table, using
% the selected PC, and show the geospatial weighting activations for the
% highlighted trend.
ax(3) = subplot(2,2,[2,4]);
geoDataMerged.IndexedValue = coeff(:,pars.PC_Index);
geoDataMerged.Properties.UserData.Response = ...
   sprintf('Component-%d (%s)',...
      pars.PC_Index,geoDataMerged.Properties.UserData.Response);
indexedLims = [...
   min(geoDataMerged.IndexedValue), ...
   max(geoDataMerged.IndexedValue) ...
   ];
S = { ...
   {'IndexedValue',indexedLims,'CData',[1 64]},...
   {'Party',"R",'CDataMapping','scaled'},...
   {'Party',"D",'CDataMapping','scaled'},...
   {'Party',"R",'FaceColor','flat'},...
   {'Party',"D",'FaceColor','flat'},...
   {'Party',"R",'EdgeColor',geoDataMerged.Properties.UserData.R},...
   {'Party',"R",'LineWidth',2},...
   {'Party',"D",'EdgeColor',geoDataMerged.Properties.UserData.D},...
   {'Party',"D",'LineWidth',2},...
   {'Party',"R",'DisplayName',"Republican State"},...
   {'Party',"D",'DisplayName',"Democratic State"} ...
};
[~,fig,h] = gfx__.showPartyMapping(geoDataMerged,S,pars,...
   'TitleText',geoDataMerged.Properties.UserData.Response,...
   'ColorBar','on','Axes',ax(3),'Figure',fig);
set(h.Children,'EdgeAlpha',0.5);
end