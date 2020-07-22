function [fig,ax] = plotTrendsByYear(E,T,varargin)
%PLOTTRENDSBYYEAR  Plots trends in education expenditures by year
%
%  fig = plotTrendsByYear(E,T);
%  [fig,ax] = plotTrendsByYear(E,T,'Name',value,...);
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
   'LineWidth',1.5,...
   'FontName','Arial',...
   'NextPlot','add'...
   };
pars.EnrollmentTrendParams = {...
   'DisplayName','Enrollment Count',...
   'FaceColor',[0.8 0.2 0.2],...
   'LineWidth',1.5,...
   'Color',[1 0 0] ...
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
   'DisplayName','Per-Student Spending (dollars)',...
   'FaceColor',[0.2 0.2 0.8],...
   'LineWidth',1.5,...
   'Color',[0 0 1] ...
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

% % Done parsing input % %

% Create the figure and axes %
fig = figure('Name','Education Spending Trends',...
   pars.FigParams{:});
ax = axes(fig,pars.AxesParams{:});

% First, add the left-axis (enrollment counts) %
studentCounts = table2array(E(2:end,:)).'; % Exclude first row (United States)
gfx__.plotWithShadedError(ax,E.Properties.UserData.t,studentCounts,...
   pars.EnrollmentTrendParams{:});
ylabel(ax,'Enrollment Counts',pars.FontParams{:});

% Next, add the right-axis (per-student spending) %
studentSpending = table2array(T(2:end,:)).';
yyaxis(ax,'right');
set(ax,'YColor','r');
gfx__.plotWithShadedError(ax,T.Properties.UserData.t,studentSpending,...
   pars.SpendingTrendParams{:});
ylabel(ax,'Per-Student Expenditures ($)',pars.FontParams{:});
yyaxis(ax,'left');
set(ax,'YColor','b');
title(ax,'1996-2016 Per-Year Enrollment and Expenditures',...
   pars.FontParams{:});
end

