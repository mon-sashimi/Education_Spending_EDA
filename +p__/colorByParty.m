function [C,iC,c] = colorByParty(party,c)
%COLORBYPARTY Return colors for observations based on .Party value
%
%  [C,iC,c] = p__.colorByParty(dataTable);
%  [C,iC,c] = p__.colorByParty(party,c);
%
% Inputs
%  dataTable - Data table with .Userdata property that contains 'R' and 'D'
%              fields indicating coloring for Republican and Democratic
%              parties, as well as a '.Party' variable. If `c` is also
%              given, then that supercedes the .UserData value.
%
%  or
%
%  party - Vector of strings or char values as "D" or "R" corresponding to
%           political party for indexing the color of some other array
%
%  c     - Color map where first row is for Republican party and second row
%           is color for Democratic party.
%
% Outputs
%  C     - Rows corresponding to input `party` or `dataTable.Party`
%  iC    - Corresponding index (1 -> Republican; 2 -> Democratic)
%  c     - Colormap used in creating `C`
%
% See also: p__, gfx__, index.mlx


if istable(party)
   if nargin < 2
      c = [party.Properties.UserData.R; ...
           party.Properties.UserData.D];
   end
   iC = strcmpi(party.Party,"D")+1;
   C = c(iC,:);
else
   iC = strcmpi(party,"D")+1;
   C = c(iC,:);
end

end