function data = getStateData(dataType)
%GETSTATEDATA Return a certain type of metadata for US states as a table
%
%  data = p__.getStateData();
%  data = p__.getStateData(dataType);
%
% Inputs
%  dataType - Type of state metadata to retrieve:
%              * Any sheet name in us-state-metdata.xlsx
%
% Output
%  data   - Data table corresponding to desired branch
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

switch lower(dataType)      
   case 'election2016'
      data = readtable('us-state-metadata.xlsx',opts,'Sheet','Election2016');
      data.Properties.UserData = struct;
      data.Properties.UserData.type = dataType;
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
   otherwise
      data = readtable('us-state-metadata.xlsx',opts,'Sheet',dataType);
      data.Properties.UserData = struct;
      data.Properties.UserData.type = dataType;
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
end
data.Properties.DimensionNames{1} = 'State';
data.Properties.Description = "State Metadata";
end