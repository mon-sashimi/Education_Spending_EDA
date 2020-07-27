function dollar_value_ks_2016 = adjustValue(year,state,dollar_value)
%ADJUSTVALUE Compute adjusted value based on year
%
%  dollar_value_ks_2016 = adjustValue(year,state,dollar_value);
%
% Inputs
%  year              - Year corresponding to ROWS of dollar_value
%  state             - State corresponding to COLUMNS of dollar_value
%  dollar_value      - Unadjusted values by year. Can be given as a scalar,
%                      vector, or matrix. If given as a column vector, must
%                      have same number of elements as `year`. Rows of
%                      dollar_value correspond to elements of `year`.
%
% Output
%  dollar_value_ks_2016 - Dollar values adjusted for purchasing power in
%                         2016 and according to relative purchasing power
%                         in state of Kansas.
%
% See also: math__, p__, index.mlx

% Check input
if ischar(state)
   state = {state};
end

% Read in data
T = p__.getCPI();
[~,P] = p__.getIncomeData();

% Select comparison values
CPI_2016 = T.CPI(T.Year==2016);
% Can use character indexing since States are Row Names:
PCI_Med_2010_2014_KS = P.PerCapitaIncome('Kansas'); 

% First, adjust for inflation over time
dollar_value_2016 = nan(size(dollar_value));
for iRow = 1:numel(year)
   CPI = T.CPI(T.Year==year(iRow));
   k_inflation = CPI_2016 / CPI;
   dollar_value_2016(iRow,:) = dollar_value(iRow,:) .* k_inflation;
end

% Next, adjust for differences in cost of living based on state
dollar_value_ks_2016 = nan(size(dollar_value_2016));
for iCol = 1:numel(state)
   PCI = P.PerCapitaIncome(state(iCol));
   k_location = PCI_Med_2010_2014_KS / PCI;
   dollar_value_ks_2016(:,iCol) = dollar_value_2016(:,iCol) .* k_location;
end

end