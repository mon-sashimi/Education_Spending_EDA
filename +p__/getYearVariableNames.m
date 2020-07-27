function varNames = getYearVariableNames(years)
%GETYEARVARIABLENAMES  Generate valid table variable names for Years
%
%  varNames = p__.getYearVariableNames();
%  varNames = p__.getYearVariableNames(years);
%
% Inputs
%  years - If not specified, assumes default range (1993:2016)
%
% Output
%  varNames - Cell array of char vectors that are variable names of format
%              {'Y1993', ... ,'Y2016'}
%
% See also: p__, p__.getEducationData.mlx

% Variable names must start with a letter
v = strsplit(sprintf('Y%d-',years),'-');
varNames = v(1:(end-1)); % Remove last element since it will be empty
end