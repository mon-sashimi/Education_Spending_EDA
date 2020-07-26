function [fig,ax] = plotTrendsByYearAndState(data,varargin)
%PLOTTRENDSBYYEARANDSTATE  Plots trends in education expenditures by year and state
%
%  fig = gfx__.plotTrendsByYearAndState(data);
%  [fig,ax] = gfx__.plotTrendsByYearAndState(data,'Name',value,...);
%
% Inputs
%  data - Table with response of interest
%           Variables:    Years
%           Observations: States
%  varargin - (Optional) 'Name',value parameter pairs
%
% Output
%  fig - Figure handle to generated figure
%  ax  - Axes handle that goes in the figure
%
% See also: index.mlx, gfx__

% % Default parameters struct (change with 'Name',value arg pairs)% %
pars = struct;
pars.AxesParams = {...
   'XColor','k',...
   'YColor','k',...
   'LineWidth',2.5,...
   'FontName','Arial',...
   'XTick',1996:4:2016,...
   'NextPlot','add'...
   };
pars.FigParams = {...
   'Color','w',...
   'Units','Normalized',...
   'Position',[0.2 0.2 0.6 0.6],...
   'NumberTitle','off' ...
   };
pars.FontParams = {...
   'Color','k',...
   'FontName','Arial'...
   };
pars.NumYTicks = 5;
pars.PartyColors = [...
   0.8 0.2 0.2; ... % Republican
   0.2 0.2 0.8  ... % Democratic
   ];
pars.TrendParams = {...
   'LineWidth',1.25,...
   'Marker','s', ...
   'MarkerSize',3,...
   'MarkerFaceColor',[0.0 0.0 0.0], ...
   };
% % 

% % Begin parsing inputs % %
fn = fieldnames(pars);

if numel(varargin) > 0
   if isstruct(varargin{1})
      pars = varargin{1};
      varargin(1) = [];
   end
end

for iV = 1:2:numel(varargin)
   idx = strcmpi(varargin{iV},fn);
   if sum(idx) == 1
      pars.(fn{idx}) = varargin{iV+1};
   end
end
% % Done parsing input % %

% Create the figure and axes %
fig = figure(...
   'Name','Education Spending Trends: By Year and State',...
   pars.FigParams{:});

if istable(data)
   data = {data};
   nRow = 1;
   nCol = 1;
elseif iscell(data)
   nRow = 1;
   nCol = numel(data);
end

ax = gobjects(nRow,nCol);
stateMeta = p__.getStateData('Election2016'); % Get party by 2016 Election result
for iData = 1:numel(data)
   thisData = outerjoin(data{iData},stateMeta,...
      'Keys',{'State'},'MergeKeys',false);
   years = thisData.Properties.UserData.t;
   states = thisData.Properties.RowNames(2:end);
   C = p__.colorByParty(thisData((2:end),:),pars.PartyColors);
   ax(iData) = subplot(nRow,nCol,iData);
   set(ax(iData),pars.AxesParams{:});
   y = table2array(data{iData}(2:end,:)).'; % Exclude first row (United States)
   for iState = 1:numel(states)
      line(ax(iData),years,y(:,iState),pars.TrendParams{:},...
         'DisplayName',states{iState},...
         'Tag',thisData.Properties.UserData.Response,...
         'Color',C(iState,:),...
         'MarkerEdgeColor',C(iState,:));
   end
   
   if numel(data)==1
      ylabel(ax(iData),data{iData}.Properties.UserData.Response,pars.FontParams{:});
      title(ax(iData),'1993-2016 Trends by State',pars.FontParams{:},'FontSize',18);
   else
      title(ax(iData),data{iData}.Properties.UserData.Response,pars.FontParams{:});
   end
   % Compute axes limits based on data so that labels don't overlap
   xl = [years(1)-0.5 years(end)+0.5];
   yl = [ax(iData).YLim(1), diff(ax(iData).YLim)*1.10 + ax(iData).YLim(1)];
   dY = diff(yl);
   yT = linspace(yl(1)+0.1*dY,yl(2)-0.1*dY,pars.NumYTicks);
   yTL = sprintf('%8.0f::',yT);
   yTL = strsplit(yTL,'::');
   % Update axes
   set(ax(iData),'XLim',xl,'YLim',yl,...
      'YTick',yT,'YTickLabel',yTL(1:(end-1)));
   text(ax(iData),1994,0.975*dY + yl(1),...
      'Presidential Party','FontName','Arial','Color','k',...
      'FontWeight','bold','FontSize',12);
   gfx__.addBranchTrendToTimeline(ax(iData),'executive','YRange',[0.9 0.95]);
end

if numel(data) > 1
   suptitle('1993-2016 Trends by State');
end

end

