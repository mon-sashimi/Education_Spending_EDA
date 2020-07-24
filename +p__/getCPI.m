function CPI = getCPI(cpi_file)
%GETCPI Read in relevant columns of Consumer-Price-Index (CPI) data table
%
%  CPI = p__.getCPI();
%  CPI = p__.getCPI(cpi_file);
%
% Inputs
%  cpi_file - (Optional) Default is 'us-cpi.xlsx' if no args provided
%
% Output
%  CPI - Table for CPI values between 1993 and 2016, by year.
%
% See also: p__, math__, index.mlx

if nargin < 1
   cpi_file = 'us-cpi.xlsx';
end

opts = spreadsheetImportOptions('NumVariables',2);
opts.VariableNamesRange = 'A1:B1';
opts.DataRange = 'A2:B25';
opts.VariableNames = {'Year','CPI'};
opts.VariableTypes = {'double', 'double'};
CPI = readtable(cpi_file,opts,'Sheet','CPI');
CPI.Properties.Description = "US Annual CPI 1993-2016";
CPI.Properties.UserData.type = 'CPI';

end