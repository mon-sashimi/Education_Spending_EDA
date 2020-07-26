% EDUCATION_SPENDING_EDA Exploratory data analysis of US Education Spending
% MATLAB Version 9.7 (R2020b Prerelease) 24-Jul-2020
%
% <strong>Packages</strong>
%  gfx__                - Contains functions for generating graphics
%  math__               - Contains some basic math functions, particularly for converting to 2016 dollar values
%  p__                  - Contains functions for parameter parsing and reading in data
%  ui__                 - Contains some ui-layout stuff that might not be used
%  
% Files
%   public-school-per-pupil-expenditures.xlsx - Spending source data (downloaded from https://ncses.nsf.gov/indicators/states/indicator/public-school-per-pupil-expenditures/map/2016)
%   us-cpi.xlsx                               - Consumer Price Index (CPI) by month and year from 1993-2016 (to match expenditures year range)
%   us-executive-branch.xlsx                  - President name & Party from 1993-2016 (to match expenditures year range)
%   us-judicial-branch.xlsx                   - Contains all Supreme Court Justices from 1993-2016, along with their Martin-Quinn ideological leanings by year (negative = liberal; positive = conservative)
%   us-legislative-branch.xlsx                - Two sheets: "Senate" and "House", each of which contains the number of seats held by party or other (1993-2016)
%   us-state-metadata.xlsx                    - Each sheet is named based on metadata that it contains and has one column of state names and one column of corresponding metadata.
%
% Scripts
%   index.mlx                - Main live script to generate html output (start here)