function geoDataSpending = mergeGeoSpendingData(geoData,T,fixedYear)
%MERGEGEOSPENDINGDATA Create geospatial data table
%
%  geoDataSpending = p__.mergeGeoSpendingData(geoData,T);
%  geoDataSpending = p__.mergeGeoSpendingData(geoData,T,fixedYear);
%
% Inputs
%  geoData   - Contains data in format for `mapshow`
%  T         - Table of educational spending per student by state 1993-2016
%  fixedYear - Any value from 1993:2016 to show as fixed "slice" (goes into
%                 geoDataSpending.Properties.UserData.FixedYear; determines
%                 value of .IndexedValue variable property). 
%                 -> Default `fixedYear` value is 1993
%
% Output
%  geoDataSpending - Combination from geoData and T merge.
%
% See also: p__, gfx__.showStateSpendingClusters, index.mlx

if nargin < 3
   fixedYear = 1993;
end

geoDataSpending = outerjoin(T,geoData,...
   'Keys',{'State'},'MergeKeys',true);
v = p__.getYearVariableNames(T.Properties.UserData.t);
geoDataSpending = mergevars(geoDataSpending,v,...
   'NewVariableName','Spending','MergeAsTable',false);
geoDataSpending.Properties.UserData.FixedYear = fixedYear;
[~,index] = min(abs(geoDataSpending.Properties.UserData.t - fixedYear));
geoDataSpending.IndexedValue = geoDataSpending.Spending(:,index);

end