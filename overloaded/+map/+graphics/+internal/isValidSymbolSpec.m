function tf = isValidSymbolSpec(symbolSpec)
%isValidSymbolSpec Check Symbol Spec
%
%   isValidSymbolSpec(symbolSpec) returns true if the SymbolSpec is valid,
%   false otherwise.
%
%   This function is for internal use.  The interface and existence of this
%   function is subject to change in future releases.
%
%   This function does not check that the rules are in the correct format.
%
% See also MAKESYMBOLSPEC.

% Copyright 2003-2012 The MathWorks, Inc.

tf = false;

if isstruct(symbolSpec) && isscalar(symbolSpec)
   fnames = fieldnames(symbolSpec);
   idx = find(strcmpi('shapetype',fnames),1);
   if ~isempty(idx)
      shapetype = symbolSpec.(fnames{idx});
      fnames(idx) = [];
      fnames = lower(fnames);
      
      switch lower(shapetype)
         
         case 'point'
            pointProperties = properties('matlab.graphics.chart.primitive.Scatter')';
            tf = ~isempty(fnames)||all(ismember(lower(fnames),pointProperties));
            
         case 'line'
            lineProperties = properties('matlab.graphics.primitive.Line')';
            tf = ~isempty(fnames)||all(ismember(lower(fnames),lineProperties));
            
         case 'polygon'
            polygonProperties = properties('matlab.graphics.primitive.Patch')';
            tf = ~isempty(fnames)||all(ismember(lower(fnames),polygonProperties));
            
      end
   end
end
