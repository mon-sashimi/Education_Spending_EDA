function properties = getOpt(properties,varargin)
%GETOPT Process paired optional arguments as 'prop1',val1,'prop2',val2,...
%
%  properties = p__.getopt(properties,varargin) 
%  >> properties = p__.getOpt(properties,'name1',val1,'name2',val2,...);
%
%  --> returns a modified properties structure, given an initial properties 
%      structure, and a list of paired arguments.
%      * Each argument pair should be of the form property_name,val where
%        property_name is the name of one of the field in properties, 
%        and val is the value to be assigned to that structure field.
%
%  properties = p__.getOpt(properties,{'name1',val1,'name2',val2})
%  --> effectively the same as previous syntax
%
%  properties = p__.getOpt(properties,matchtype,varargin);
%  >> properties = p__.getOpt(properties,0,'name1',val1,...);
%  >> properties = p__.getOpt(properties,1,'name1',val1,...);
%  >> properties = p__.getOpt(properties,2,'name1',val1,...);
%  >> properties = p__.getOpt(properties,3,'name1',val1,...);
%  >> properties = p__.getOpt(properties,4,'name1',val1,...);
%  >> properties = p__.getOpt(properties,5,'name1',val1,...);
%
%  --> Same as previous two cases, except slight change in property
%        "matching" behavior:
%  Case 0 (default): Each property name must match (case-sensitive); throws
%                    an error if there is a mismatched name.
%  Case 1: Each property name must match (case-insensitive); throws
%                    an error if there is a mismatched name.
%  Case 2: Property must match (case-sensitive) for assignment; does not
%           throw an error on mismatch and instead just skips assignment.
%  Case 3: Property must match (case-insensitive) for assignment; does not
%           throw an error on mismatch and instead just skips assignment.
%  Case 4: Property does not need to match (case-sensitive) for assignment.
%           Creates a new field if that field did not exist in `properties`
%  Case 5: Property does not need to match (case-insensitive) for
%           assignment. Create new field in `properties` if not existant.
%
%     EXAMPLE:
%   properties = struct('zoom',1.0,'aspect',1.0,'gamma',1.0,'file',[],'bg',[]);
%   properties = p__.getOpt(properties,'aspect',0.76,'file','mydata.dat')
% would return:
%   properties =
%         zoom: 1
%       aspect: 0.7600
%        gamma: 1
%         file: 'mydata.dat'
%           bg: []
%
% Typical usage in a function:
%   properties = parse.getOpt(properties,1,varargin{:}); % case-insensitive, "strict" match
%
% Function from
% http://mathforum.org/epigone/comp.soft-sys.matlab/sloasmirsmon/bp0ndp$crq5@cui1.lmms.lmco.com
%
% dgleich
% 2003-11-19
% 	-- added ability to pass a cell array of properties
%
% m053m716
% 2020-02-04
%   -- added different "matchtype" categories
%	-- changed syntax to "package" format
%   -- changed name to camelCase 
%	-- added error messages and identifiers

if isempty(varargin)
   return; % No need to do anything.
end

% Parse matchtype from inputs
if isnumeric(varargin{1})
   matchtype = varargin{1};
   varargin(1) = [];
else
   matchtype = 0;
end

if iscell(varargin{1})
   varargin = varargin{1};
end

% Check that number of inputs makes sense
nPropArgs = numel(varargin);
if mod(nPropArgs,2)~=0
   error(['P__:' mfilename ':BadFormat'],...
      ['\n\t->\t<strong>[P__.GETOPT]:</strong> ' ...
	  'Property names and values must be specified in pairs.\n']);
end

% Based on matchtype, give "matching" function
prop_names = fieldnames(properties);
switch matchtype
   case 0
      matchFun = @(propStruct,toMatch,toAssign)matchCaseStrict(prop_names,propStruct,toMatch,toAssign);
   case 1
      matchFun = @(propStruct,toMatch,toAssign)matchStrict(prop_names,propStruct,toMatch,toAssign);
   case 2
      matchFun = @(propStruct,toMatch,toAssign)matchCaseSkip(prop_names,propStruct,toMatch,toAssign);
   case 3
      matchFun = @(propStruct,toMatch,toAssign)matchSkip(prop_names,propStruct,toMatch,toAssign);
   case 4
      matchFun = @(propStruct,toMatch,toAssign)matchCaseAssign(propStruct,toMatch,toAssign);
   case 5
      matchFun = @(propStruct,toMatch,toAssign)matchAssign(prop_names,propStruct,toMatch,toAssign);
   otherwise
      error(['P__:' mfilename ':BadCase'],...
         ['\n\t->\t<strong>[P__.GETOPT]</strong>: ' ...
		  '`matchtype` value (%g) is out of range\n'],matchtype);
end

for iProp=1:2:nPropArgs
   propName = varargin{iProp};
   if ~ischar(propName)
      error(['P__:' mfilename ':BadClass'],...
         ['\n\t->\t<strong>[P__.GETOPT]</strong>: ' ...
		  'Property names must be character arrays.\n']);
   end
   propVal = varargin{iProp+1};
   properties = matchFun(properties,propName,propVal);
   
end

% Different "matching" functions depend on matchtype case
   function propstruct = matchCaseStrict(allnames,propstruct,tomatch,toassign)
      %MATCHCASESTRICT  For matchtype 0, strictest (case-sensitive) match
      idx = strcmp(allnames, tomatch);
      if sum(idx)~=1
         fprintf(1,'\n\t<strong>Valid Field/Property Names:</strong>\n');
         fprintf(1,'\t\t->\t<strong>%s</strong>\n',allnames{:});
         fprintf(1,'\n');
         error(['P__:' mfilename ':BadName'],...
            ['\n\t->\t<strong>[P__.GETOPT]</strong>: ' ...
            'Invalid property <strong>''',tomatch,'''</strong>; ' ...
            'must be one of the field names listed above.\n']);
      end
      propstruct.(tomatch) = toassign;
   end

   function propstruct = matchStrict(allnames,propstruct,tomatch,toassign)
      %MATCHSTRICT  For matchtype 1, stills throw error on
      %              (case-insensitive) mismatch
      idx = strcmpi(allnames, tomatch);
      if sum(idx)~=1 
         fprintf(1,'\n\t<strong>Valid Field/Property Names:</strong>\n');
         fprintf(1,'\t\t->\t<strong>%s</strong>\n',allnames{:});
         fprintf(1,'\n');
         error(['P__:' mfilename ':BadName'],...
            ['\n\t->\t<strong>[P__.GETOPT]</strong>: ' ...
            'Invalid property <strong>''',tomatch,'''</strong>; ' ...
            'must be one of the field names listed above\n']);
      end
      propstruct.(allnames{idx}) = toassign;
   end

   function propstruct = matchCaseSkip(allnames,propstruct,tomatch,toassign)
      %MATCHCASESKIP  For matchtype 2, case-sensitive; skip if not there
      idx = strcmp(allnames, tomatch);
      if sum(idx)~=1 
         return;
      end
      propstruct.(tomatch) = toassign;
   end

   function propstruct = matchSkip(allnames,propstruct,tomatch,toassign)
      %MATCHCASESKIP  For matchtype 3, case-insensitive; skip if not there
      idx = strcmpi(allnames, tomatch);
      if sum(idx)~=1 
         return;
      end
      propstruct.(allnames{idx}) = toassign;
   end

   function propstruct = matchCaseAssign(propstruct,tomatch,toassign)
      %MATCHCASEASSIGN  For matchtype 4, case-sensitive; assign regardless
      propstruct.(tomatch) = toassign;
   end

function propstruct = matchAssign(allnames,propstruct,tomatch,toassign)
      %MATCHASSIGN  For matchtype 5, case-insensitive; assign regardless
      idx = strcmpi(allnames, tomatch);
      if sum(idx)~=1 
         propstruct.(tomatch) = toassign;
      else
         propstruct.(allnames{idx}) = toassign;
      end
   end

end