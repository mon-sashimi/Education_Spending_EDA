function [H,P] = getIncomeData(income_file)
%GETINCOMEDATA Read in data for by-state household/per-capita income
%
%  [H,P] = p__.getIncomeData();
%  [H,P] = p__.getIncomeData(income_file);
%
% Inputs
%  income_file - (Optional) Default is 'us-income.xlsx' if no args provided
%
% Output
%  H - Table of household median incomes values from 2013-2018
%  P - Table of per-capita median incomes (2010-2014)
%
% See also: p__, math__, index.mlx

if nargin < 1
   income_file = 'us-income.xlsx';
end

h_opts = spreadsheetImportOptions('NumVariables',5);
h_opts.VariableNamesRange = 'B1:F1';
h_opts.DataRange = 'B2:F52';
h_opts.RowNamesRange = 'A2:A52';
h_opts.VariableTypes = {'double', 'double', 'double', 'double', 'double'};
H = readtable(income_file,h_opts,'Sheet','MedianIncome');
H.Properties.Description = "US Median Household Income 2014-2018";
H.Properties.UserData.type = 'HouseholdIncome';
H.Properties.VariableUnits = {'dollars','dollars','dollars','dollars','dollars'};

p_opts = spreadsheetImportOptions('NumVariables',6);
p_opts.VariableNamesRange = 'B1:G1';
p_opts.DataRange = 'B2:G52';
p_opts.RowNamesRange = 'A2:A52';
p_opts.VariableTypes = {'double','double','double','double','double','double'};
P = readtable(income_file,p_opts,'Sheet','PerCapitaIncome');
P.Properties.Description = "US Per Capita Income 2010-2014";
P.Properties.UserData.type = 'PerCapitaIncome';
P.Properties.VariableUnits = {'count','count','count','dollars','dollars','dollars'};

end