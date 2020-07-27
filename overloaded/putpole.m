function origin = putpole(polemat,units)
%PUTPOLE  Origin vector to place north pole at specific point
%
%  origin = PUTPOLE(polemat) computes the origin of a map, given the
%  location of the north pole (90,0).  This determines the proper
%  orientation vector which will locate the north pole at the specified
%  point in the base coordinate system.
%
%  The input matrix is of the form pole = [lat, lon, meridian],
%  where [lat,lon] is the location of the north pole in the
%  transformed coordinate system, and meridian is the central meridian
%  from the original map on which the transformed system is centered.
%  If meridian is omitted, then meridian = lon is assumed.  Lat, lon
%  and meridian may be column vectors.  The output matrix is of
%  the form origin = [lat, lon, orient], where [lat, lon] = the center
%  point of the map and orient = the north pole azimuth measured
%  from the center point.
%
%  origin = PUTPOLE(polemat,'units') defines the 'units' of the input
%  and output data.  If omitted, 'degrees' are assumed.
%
%  See also NEWPOLE, ORG2POL.

% Copyright 1996-2015 The MathWorks, Inc.
% Written by:  E. Byrns, E. Brown

narginchk(1,2)

if nargin == 1
    units = 'degrees';
end

%  Argument dimensionality tests
%  Remember that polemat may be a three column matrix where
%  each row is a represents a pole vector

if ndims(polemat) > 2                       % Prohibit n dimensional inputs
     error(['map:' mfilename ':mapError'], ...
         'Pole input can not contain pages')
end

if size(polemat,2) == 1
    % Ensure row vectors
    polemat = polemat';
end

if size(polemat,2) == 2
    polemat(:,3) = polemat(:,2);
elseif size(polemat,2) ~= 3
    error(['map:' mfilename ':mapError'], ...
        'Pole input must have three columns')
end

%  Transform input data to radians

polemat = toRadians(units, polemat);

%  Compute the azimuth and distance to the pole location.

[poledist, orient] = distance('gc',0,0,polemat(:,1),polemat(:,2),'radians');

%  Compute the origin latitude

lat = pi/2 - poledist;

%  Transform the origin data for proper output

origin = npi2pi([lat polemat(:,3) orient],'radians');
origin = real(fromRadians(units,origin));
