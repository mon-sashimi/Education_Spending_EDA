function [data,fig,h] = showPartyMapping(data,symbolspec,varargin)
%SHOWPARTYMAPPING  Make plot to map some value to state colors
%
%  [data,fig,h] = gfx__.showPartyMapping();
%     -> Defaults to showing state party by 2016 election.
%
%  [data,fig,h] = gfx__.showPartyMapping(data);
%     -> Use different data table from default
%
%  [data,fig,h] = gfx__.showPartyMapping(data,symbolspec);
%     -> See makesymbolspec for details about symbolspec; pre-specify rules
%        for how each polygon is colored in.
%
%  [__] = gfx__.showPartyMapping(data,__,'Name',value,...);
%     -> Uses 'Name',value pair arguments for the following optional
%        property pairs:
%        * 'Axes' : [] (def) | Can give an axes handle to specify axes
%        * 'Figure' : [] (def) | Can give a figure handle to specify figure
%        * 'Legend' : 'on' (def) | 'off'   -> Useful for categorization
%
%        * 'LegendIndices' : [1 7];        -> First Rep. & Dem. states
%                                               respectively
%        * 'ColorBar' : 'on' | 'off' (def) -> Useful if indexing range of
%                                               values
%        * 'ColorMap' : jet(64) (def) -> Color mapping if colorbar is on
%        * 'ColorRange' : [nan nan] (def) -> Range if colorbar is on
%                                         * Gets parsed from data anyways;
%                                           unless this is set to a non-NaN
%                                           value.
%        * 'TitleText' : (If using `symbolspec`, this can be used to change
%                          the title of the axes)
%
% Inputs
%  data - Data table with geospatial .X and .Y and some mapping indices.
%        -> If not given this is loaded from combination of built-in Matlab
%           geospatial coordinates (see p__.getStateData('Election2016'))
%           and 2016 Election result data table.
%        -> (Optional) `data` can be given as a char array indicating which
%            input to load from p__.getStateData.
%
%  symbolspec - See makesymbolspec; cell array containing rules for how to
%                 color in the state polygons or set other properties.
%
% Output
%  data - Data table used to generate figure
%  fig  - Figure handle
%  h    - Handle to generated group with "patch" object array (states)

% Parse optional input argument pairs %
pars = struct;
pars.Axes = [];
pars.Figure = [];
pars.Legend = 'on';
pars.LegendIndices = [1 7];
pars.LegendLocation = 'southwest';
pars.ColorBar = 'off';
pars.ColorBarLocation = 'east';
pars.ColorMap   = flipud(jet(64));
pars.ColorRange = [1 64];
pars.TitleText = "";
fn = fieldnames(pars);
allowNewTitle = true;
if nargin >= 3
   if ischar(symbolspec)
      varargin = [symbolspec, varargin];
      symbolspec = {...
         {'Party',"R",'FaceColor',data.Properties.UserData.R},...
         {'Party',"R",'EdgeColor','none'},...
         {'Party',"R",'DisplayName',"Republican State"},...
         {'Party',"D",'FaceColor',data.Properties.UserData.D},...
         {'Party',"D",'EdgeColor','none'},...
         {'Party',"D",'DisplayName',"Democratic State"} ...
      };  
      allowNewTitle = false;
   end
end
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
if isempty(pars.Figure)
   if isempty(pars.Axes)
      fig = figure(...
         'Name','Classifed "Red" and "Blue" States',...
         'Color','w',...
         'Units','Normalized',...
         'Position',[0.35 0.50 0.40 0.40]); 
   else
      fig = get(pars.Axes,'Parent');
   end
else
   fig = pars.Figure;
end

if isempty(pars.Axes)
   ax = axes(fig,...
      'Color','none','XColor','none','YColor','none','NextPlot','add',...
      'FontName','Arial','Tag','United States Axes',...
      'Colormap',pars.ColorMap,'CLim',pars.ColorRange);
else
   ax = pars.Axes;
   set(ax,...
      'Color','none','XColor','none','YColor','none','NextPlot','add',...
      'FontName','Arial','Tag','United States Axes',...
      'Colormap',pars.ColorMap,'CLim',pars.ColorRange);
end

if nargin < 1
   data = p__.getStateData('Election2016');
elseif ischar(data)
   data = p__.getStateData(data);
end

geoData = mapshape(table2struct(data));
if nargin < 2
   symbolspec = {...
      {'Party',"R",'FaceColor',data.Properties.UserData.R},...
      {'Party',"R",'EdgeColor','none'},...
      {'Party',"R",'DisplayName',"Republican State"},...
      {'Party',"D",'FaceColor',data.Properties.UserData.D},...
      {'Party',"D",'EdgeColor','none'},...
      {'Party',"D",'DisplayName',"Democratic State"} ...
   };   
   allowNewTitle = false;
end

S = makesymbolspec('Polygon',symbolspec{:});
h = mapshow(ax,geoData,'SymbolSpec',S);
set(h.Children,{'Tag'},data.Properties.RowNames);
if allowNewTitle
   title(ax,pars.TitleText,...
      'FontName','Arial','Color','k');   
else
   title(ax,'United States: Red and Blue States (2016 Election)',...
      'FontName','Arial','Color','k');
end
if strcmpi(pars.Legend,'on')
   for iL = 1:numel(pars.LegendIndices)
      h.Children(iL).Annotation.LegendInformation.IconDisplayStyle = 'on';
   end
   legend(h.Children(pars.LegendIndices),...
      'TextColor','k',...
      'FontName','Arial',...
      'Color','none',...
      'Location',pars.LegendLocation);
end
if strcmpi(pars.ColorBar,'on')
   nTick = 4;
   dC = 0.05*range(data.IndexedValue);
   cTick = linspace(min(data.IndexedValue)+dC,max(data.IndexedValue)-dC,nTick);
   dR = 0.05*diff(pars.ColorRange);
   cTickLoc = linspace(pars.ColorRange(1)+dR,pars.ColorRange(2)-dR,nTick);
   
   if max(cTick) > 1e4
      cTickLab = strsplit(sprintf('%8.1fk::',cTick./1e3),'::');
   else
      cTickLab = strsplit(sprintf('%8.2f::',cTick),'::');
   end
      
   cb = colorbar(ax,...
      'Location',pars.ColorBarLocation,...
      'Ticks',cTickLoc,...
      'TickLabels',strtrim(cTickLab(1:(end-1))),...
      'AxisLocation','out',...
      'FontName','Arial');
   cb.Label.String = data.Properties.UserData.Response;
   cb.Label.FontName = 'Arial';
   cb.Label.Color = [0 0 0];
end


end