function data = getBranchData(branch)
%GETBRANCHDATA Return data for a specific branch of US government 1993-2016
%
%  data = p__.getBranchData();
%  data = p__.getBranchData(branch);
%
% Inputs
%  branch - 'executive' (def) | 'legislative' | 'judicial' | 'senate' |
%                 'house' | '[specific supreme court justice name]'
%
% Output
%  data   - Data table corresponding to desired branch
%
% See also: p__, index.mlx, gfx__.addBranchTrendToTimeline

if nargin < 1
   branch = 'executive';
end

switch lower(branch)
   case {'executive','president'}
      opts = spreadsheetImportOptions('NumVariables',3);
      opts.VariableNamesRange = 'A1:C1';
      opts.DataRange = 'A2:C25';
      opts.VariableTypes = {'double', 'string', 'string'};
      data = readtable('us-executive-branch.xlsx',opts,'Sheet','President');
      data.Properties.Description = "US Presidents 1993-2016 Party & Name";
      data.Properties.UserData = struct;
      data.Properties.UserData.type = 'Executive';
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
   case {'judicial','supreme court','scotus'}
      opts = spreadsheetImportOptions('NumVariables',8);
      opts.VariableNamesRange = 'A1:H1';
      opts.DataRange = 'A2:H218';
      opts.VariableTypes = {'double','double','string',...
         'double','double','double','double','double'};
      data = readtable('us-judicial-branch.xlsx',opts,'Sheet','MQ_Scores');
      data.Properties.Description = "SCOTUS 1993-2016 Justices & MQ Scores";
      data.Properties.UserData = struct;
      data.Properties.UserData.type = 'Judicial';
   case {'legislative','congress'}
      S = p__.getBranchData('senate');
      H = p__.getBranchData('house');
      data = outerjoin(S,H,...
         'LeftKeys',{'Year'},'RightKeys',{'Year'},'MergeKeys',true);
      data.Properties.Description = "US Congress 1993-2016 Party Breakdown";
      data.Properties.UserData = struct;
      data.Properties.UserData.type = 'Legislative';  
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
   case 'senate'
      opts = spreadsheetImportOptions('NumVariables',4);
      opts.VariableNamesRange = 'A1:D1';
      opts.DataRange = 'A2:D25';
      opts.VariableTypes = {'double', 'double', 'double','double'};
      data = readtable('us-legislative-branch.xlsx',opts,'Sheet','Senate');
      data.Properties.Description = "US Senate 1993-2016 Party Breakdown";
      data.Properties.UserData = struct;
      data.Properties.UserData.type = 'Senate';
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
   case 'house'
      opts = spreadsheetImportOptions('NumVariables',4);
      opts.VariableNamesRange = 'A1:D1';
      opts.DataRange = 'A2:D25';
      opts.VariableTypes = {'double', 'double', 'double','double'};
      data = readtable('us-legislative-branch.xlsx',opts,'Sheet','House');
      data.Properties.Description = "US House 1993-2016 Party Breakdown";
      data.Properties.UserData = struct;
      data.Properties.UserData.type = 'House';
      data.Properties.UserData.R = [0.8 0.2 0.2]; % Rep - Red
      data.Properties.UserData.D = [0.2 0.2 0.8]; % Dem - Blue
   otherwise
      data = p__.getBranchData('judicial');
      data = data(strcmpi(data.Name,branch),:);
      data.Properties.Description = sprintf('%s 1993-2016 MQ Scores',branch);
      data.Properties.UserData = struct;
      data.Properties.UserData.type = 'Judicial';
end
end