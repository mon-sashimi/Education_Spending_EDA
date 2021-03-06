function [fig,ax] = plotTrendsByYear(E,T,varargin)
%PLOTTRENDSBYYEAR  Plots trends in education expenditures by year
%
%  fig = gfx__.plotTrendsByYear(E,T);
%  [fig,ax] = gfx__.plotTrendsByYear(E,T,'Name',value,...);
%
% Inputs
%  E - Table of total enrollment counts by state & year
%        Variables:    Years
%        Observations: States
%  T - Table of per-student expenditures (dollars) by state & year
%        Variables:    Years
%        Observations: States
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
   'YColor','b',...
   'LineWidth',2.5,...
   'FontName','Arial',...
   'NextPlot','add'...
   };
pars.CB = 0.90;
pars.EnrollmentTrendParams = {...
   'DisplayName',E.Properties.UserData.Response,...
   'FaceColor',[0.8 0.2 0.2],...
   'LineWidth',1.5,...
   'Color',[1 0 0], ...
   'Marker','s', ...
   'MarkerFaceColor',[0.0 0.0 0.0], ...
   'MarkerEdgeColor',[1.0 0.0 0.0] ...
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
pars.SpendingTrendParams = {...
   'DisplayName',T.Properties.UserData.Response,...
   'FaceColor',[0.2 0.2 0.8],...
   'LineWidth',2.5,...
   'Color',[0.0 0.0 1.0],...
   'Marker','o', ...
   'MarkerFaceColor',[0.0 0.0 0.0], ...
   'MarkerEdgeColor',[0.0 0.0 1.0] ...
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

% Check table inputs
if ~strcmp(E.Properties.UserData.type,'Enrollment')
   error('First input table should be total enrollments per year');
end
if ~strcmp(T.Properties.UserData.type,'Per-Pupil')
   error('Second input table should be per-pupil expenditures per year');
end
years = T.Properties.UserData.t;
% % Done parsing input % %

% Create the figure and axes %
fig = figure('Name','Education Spending Trends',...
   pars.FigParams{:});
ax = axes(fig,pars.AxesParams{:});

% First, add the left-axis (enrollment counts) %
studentCounts = table2array(E).'; % Exclude first row (United States)
sortedCounts = sort(studentCounts,2,'ascend'); % Get percentiles for each year
nObs = size(sortedCounts,2);
p_bounds = [floor((1-pars.CB)/2 * nObs),...
            ceil(((pars.CB + (1-pars.CB)/2)) * nObs)];
hCounts = gfx__.plotWithShadedError(ax,years,...
   median(sortedCounts,2),...
   sortedCounts(:,p_bounds),...
   pars.EnrollmentTrendParams{:});

% Next, add the right-axis (per-student spending) %
studentSpending = table2array(T).';
sortedSpending = sort(studentSpending,2,'ascend');
nObs = size(sortedSpending,2);
p_bounds = [floor((1-pars.CB)/2 * nObs),...
            ceil(((pars.CB + (1-pars.CB)/2)) * nObs)];
yyaxis(ax,'right');
set(ax,'YColor','b','YLim',[0 2.5e4]);
hSpending = gfx__.plotWithShadedError(ax,years,...
   median(sortedSpending,2),...
   sortedSpending(:,p_bounds), ...
   pars.SpendingTrendParams{:});
ylabel(ax,T.Properties.UserData.Response,pars.FontParams{:});
yyaxis(ax,'left');
ylabel(ax,E.Properties.UserData.Response,pars.FontParams{:});
title(ax,'\rm1993-2016 \bfMedian\rm Per-Year Enrollment and Adjusted Expenditures',...
   pars.FontParams{:},'FontSize',18);
set(ax,'XLim',[years(1)-0.5 years(end)+0.5],'YColor','r','YLim',[0 1]);
text(ax,1994,0.975,'Presidential Party','FontName','Arial','Color','k',...
   'FontWeight','bold','FontSize',12);
gfx__.addBranchTrendToTimeline(ax,'executive','YRange',[0.9 0.95]);


legend([hCounts; hSpending],...
   'TextColor','white',...
   'Color','black',...
   'FontName','Arial',...
   'FontSize',14,...
   'FontWeight','bold',...
   'Location','southeast');

end

