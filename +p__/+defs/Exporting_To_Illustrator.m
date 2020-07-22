function varargout = Exporting_To_Illustrator(varargin)
%EXPORTING_TO_ILLUSTRATOR  Defaults for vector graphics export function
%
%  pars = defs.Exporting_To_Illustrator();
%  [v1,v2,...] = defs.Exporting_To_Illustrator('var1','var2',...);

pars = struct;

% Default filename
pars.DefaultName = ['Matlab_Vector_Graphics_Export_' ...
   datestr(datetime,'YYYY-mm-dd')];

%Boolean options
pars.AutoFormat = struct(...
   'Font',true,    ...     % Automatically reconfigure axes fonts
   'Figure',true,  ...     % Automatically reconfigure figure properties
   'Filename',true,...     % Automatically fix filename
   'Axes',true     ...     % Automatically reconfigure axes properties
   );

%Figure property modifiers
pars.FontName = 'Arial';                 %Set font name (if FORMATFONT true)
pars.FontSize = 16;                      %Set font size (if FORMATFONT true)

%Print function modifiers
pars.FormatType = '-depsc';              % EPS Level 3 Color
% pars.FormatType  = '-dpsc2';             % Vector output format
% pars.FormatType = '-dpdf';               % Full-page PDF
% pars.FormatType = '-dsvg';               % Scaleable vector graphics format
% pars.FormatType = '-dpsc';               % Level 3 full-page PostScript, color
% pars.FormatType = '-dmeta';              % Enhanced Metafile (WINDOWS ONLY)
% pars.FormatType = '-dtiffn';             % TIFF 24-bit (not compressed)
pars.UIOpt       = '-noui';              % Excludes UI controls
% pars.FormatOpt   = {'-cmyk'};              % Format options for color
% pars.FormatOpt   = {'-loose'};             % Use loose bounding box
pars.FormatOpt = {'-cmyk','-loose','-tiff'}; % Uses all options in cell ('-tiff' shows preview; eps, ps only)
pars.Renderer    = '-painters';          % Graphics renderer
pars.Resize = '';
% pars.Resize      = '-fillpage';        % Alters aspect ratio
% pars.Resize      = '-bestfit';         % Choose best fit to page
pars.Resolution  = '-r600';              % Specify dots per inch (resolution)
pars.ClassIgnoreList = {...   % List of "bad" child classes to skip setting fonts
   'matlab.ui.container.Menu'; ...
   'matlab.ui.container.Toolbar'; ...
   'matlab.ui.container.ContextMenu'; ...
   'matlab.graphics.illustration.Legend' ...
   };

if nargin < 1
   varargout = {pars};   
else
   F = fieldnames(pars);   
   if (nargout == 1) && (numel(varargin) > 1)
      varargout{1} = struct;
      for iV = 1:numel(varargin)
         idx = strcmpi(F,varargin{iV});
         if sum(idx)==1
            varargout{1}.(F{idx}) = pars.(F{idx});
         end
      end
   elseif nargout > 0
      varargout = cell(1,nargout);
      for iV = 1:nargout
         idx = strcmpi(F,varargin{iV});
         if sum(idx)==1
            varargout{iV} = pars.(F{idx});
         end
      end
   else
      for iV = 1:nargin
         idx = strcmpi(F,varargin{iV});
         if sum(idx) == 1
            fprintf('<strong>%s</strong>:',F{idx});
            disp(pars.(F{idx}));
         end
      end
   end
end

end