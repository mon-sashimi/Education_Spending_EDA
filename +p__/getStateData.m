function [data,states] = getStateData(dataType)
%GETSTATEDATA Return a certain type of metadata for US states as a table
%
%  data = p__.getStateData();
%  data = p__.getStateData(dataType);
%  [data,states] = p__.getStateData(dataType);
%
% Inputs
%  dataType - Type of state metadata to retrieve:
%              * Any sheet name in us-state-metdata.xlsx
%
% Output
%  data   - Data table corresponding to desired branch
%  states - State geodata struct for spatial plots
%
% See also: p__, index.mlx, gfx__.addBranchTrendToTimeline

if nargin < 1
   dataType = 'Election2016';
end

opts = spreadsheetImportOptions('NumVariables',1);
opts.RowNamesRange = 'A2:A52';
opts.VariableNamesRange = 'B1';
opts.DataRange = 'B2:B52';
opts.VariableTypes = {'string'};
states = p__.readStateGeoData();

switch lower(dataType)      
   case 'election2016'
      data = [readtable('us-state-metadata.xlsx',...
               opts,'Sheet','Election2016'),struct2table(states)];
      if nargout > 1
         tmp = cellstr(data.Party);
         [states.PARTY] = deal(tmp{:});
      end
      data.Properties.UserData = struct;
      data.Properties.UserData.type = dataType;
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
      data.Properties.UserData.Response = "State Party";
   otherwise
      data = [readtable('us-state-metadata.xlsx',...
               opts,'Sheet',dataType),struct2table(states)];
      data.Properties.UserData = struct;
      data.Properties.UserData.type = dataType;
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
      data.Properties.UserData.Response = dataType;
end
data.Properties.DimensionNames{1} = 'State';
data.Properties.Description = "State Metadata";

end