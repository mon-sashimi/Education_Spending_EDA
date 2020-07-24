function h = addBranchTrendToTimeline(ax,branch,varargin)
%ADDADMINISTRATIONTIMELINE  Adds trend for a US Governmental Branch to timeline
%
%  h = gfx__.addBranchTrendToTimeline();
%  h = gfx__.addBranchTrendToTimeline(ax);
%  h = gfx__.addBranchTrendToTimeline(ax,branch);
%  h = gfx__.addBranchTrendToTimeline(ax,branch,'Name',value,...);
%
% Inputs
%  ax       - Handle for axes to add trend to. If unspecified, adds to
%              current axes (`gca`)
%  branch   - (Optional) 'executive' (def) | 'judicial' | 'legislative' |
%                          'house' | 'senate' | '[specific judge name]'
%  varargin - (Optional) 'Name',value input argument pairs
%
% Output
%  h        - Handle for graphics object added to `ax`
% 
% See also: gfx__, index.mlx

if nargin < 1
   ax = gca;
end

if nargin < 2
   branch = 'executive';
end

pars = struct;
pars.DataRange = nan;
pars.DelimAnnotation = 'off';
pars.PatchAlpha = 0.5;
pars.PatchAnnotation = 'off';
pars.PatchEdgeColor = 'none';
pars.PatchNamePropPairs = {};
pars.YRange = [0.9 1.0]; % Fraction of y-axis range in which to put trend
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

switch lower(branch)
   case 'executive'
      data = p__.getBranchData('executive');
      if isnan(pars.DataRange(1))
         pars.DataRange = [0 1];
      end
      Y = scaleData([0; 1],ax,pars);
      [F,V] = makeFaceSquareRow(data.Year,Y);
      C = [data.Properties.UserData.R; ...
           data.Properties.UserData.D];
      iC = strcmpi(data.Party,"D")+1;
      h = hggroup(ax,'DisplayName',"Party Affiliation");
      hPatch = patch(...
         'Faces',F,...
         'Vertices',V,...
         'Parent',h,...
         'FaceColor','flat',...
         'CData',reshape(C(iC,:),1,numel(iC),3),...
         'EdgeColor',pars.PatchEdgeColor,...
         'FaceAlpha',pars.PatchAlpha,...
         'EdgeAlpha',pars.PatchAlpha,...
         'DisplayName',"President Party",...
            pars.PatchNamePropPairs{:});
      text(data.Year,ones(size(data.Year)).*mean(Y),data.Party,...
         'FontName','Arial',...
         'FontWeight','bold',...
         'HorizontalAlignment','center',...
         'FontSize',9,...
         'Color',[0.0 0.0 0.0],...
         'Parent',h);
      % Get years where president party changed
      delta = find([false; diff(iC)~=0]);
      xYears = (data.Year(delta)-0.5)'; % To place it on "year border"
      xYears = [xYears; xYears; nan(size(xYears))];      
      yYears = [repmat(ax.YLim,numel(delta),1), nan(numel(delta),1)]';
      hDelim = line(xYears(:),yYears(:),'LineStyle',':',...
         'LineWidth',1.5,'Color',[0.25 0.25 0.25],...
         'DisplayName','Party Change','Parent',h);
      hDelim.Annotation.LegendInformation.IconDisplayStyle = ...
         pars.DelimAnnotation;
      hPatch.Annotation.LegendInformation.IconDisplayStyle = ...
         pars.PatchAnnotation;
      
   case 'judicial'
      data = p__.getBranchData('judicial');
   case 'house'
      data = p__.getBranchData('house');
   case 'senate'
      data = p__.getBranchData('senate');
   case 'legislative'
      data = p__.getBranchData('legislative');
   otherwise
      data = p__.getBranchData(branch);
      if isempty(data)
         error(['GFX__:' mfilename ':BadDataName'],...
            ['\n\t->\t<strong>[GFX__.ADDBRANCHTRENDTOTIMELINE]</strong>: '...
             'No matching SC Justice ("%s"), check spelling\n'],branch);
      end
end

   % Scales data to range set by axes and parameters
   function z = scaleData(y,ax,pars)
      %SCALEDATA Scales data to range set by axes and parameters
      %
      %  z = scaleData(y,ax,pars);
      %  
      % Inputs
      %  y    - Data to be scaled (vector)
      %  ax   - Axes object
      %  pars - Parameters struct with `YRange` field
      %
      % Output
      %  z    - y, scaled so that `pars.DataRange` maps to `pars.YRange`
      %
      % See also: gfx__.addBranchTrendToTimeline
      
      rY = pars.DataRange;
      dY = rY(2) - rY(1);
      rPercent = pars.YRange;
      dPercent = rPercent(2) - rPercent(1);
      rAx = ax.YLim;
      dAx = rAx(2) - rAx(1);
      
      d = y - rY(1);
      p = d ./ dY;
      
      P = p.*dPercent + rPercent(1);
      
      z = P.*dAx + rAx(1);
   end

   % Makes grid for row of squares
   function [F,V] = makeFaceSquareRow(x,y)
      %MAKEFACESQUAREROW Make row of square face indices/vertices
      %
      % [F,V] = makeFaceSquareRow(x,y);
      %
      % Inputs
      %  x - (Years) X-data for each row center
      %  y - (Upper/Lower bounds on row) Y-data for lower/upper vertices
      %
      % Output
      %  F - Patch 'Faces' argument, rows are indices of vertices for each
      %        consecutive patch face
      %  V - Vertex coordinates; first column is X, second column is Y
      %
      % See also: gfx__.addBranchTrendToTimeline
      
      n = numel(x); % Number of faces
      if isrow(x)
         x = x';
      end
      if isrow(y)
         y = y';
      end
      
      % Need to offset x values since they are centers (i.e. need to expand
      % to n + 1 values of x, for n square vertical edges).
      dX = diff(x)./2; % Compute half-differences for offsets -> (n - 1) vals
      dX = [-dX(1); dX; dX(end)]; % Use first & last half-differences at ends -> (n + 1) vals
      X = [x(1); x] + dX; % Here is where it's expanded and offset
      
      % For n bins, there are n+1 edges. 
      % Note: already have n+1 Y-values (for a row, n == 1), which is why
      %       that vector doesn't have to be expanded unlike x.
      V = [repelem(X,2,1), repmat(y,n+1,1)]; % Construct vertices
      
      % Bottom-left -> Top-left -> Top-right -> Bottom-right -> Bottom-left
      F = ones(n,1) * [1,2,4,3,1] + (0:2:(2*(n-1)))';
   end

end