function dollar_value_2016 = adjustValue(year,dollar_value)
%ADJUSTVALUE Compute adjusted value based on year
%
%  dollar_value_2016 = adjustValue(year,dollar_value);
%
% Inputs
%  year              - Year corresponding to ROWS of dollar_value
%  dollar_value      - Unadjusted values by year. Can be given as a scalar,
%                      vector, or matrix. If given as a column vector, must
%                      have same number of elements as `year`. Rows of
%                      dollar_value correspond to elements of `year`.
%
% Output
%  dollar_value_2016 - Dollar values adjusted for purchasing power in 2016
%
% See also: math__, p__, index.mlx

T = p__.getCPI();

CPI_2016 = T.CPI(T.Year==2016);
dollar_value_2016 = nan(size(dollar_value));
for ii = 1:numel(year)
   CPI = T.CPI(T.Year==year(ii));
   k = CPI_2016 / CPI;
   dollar_value_2016(ii,:) = dollar_value(ii,:) .* k;
end

end