function states = readStateGeoData()
%READSTATEGEODATA  Read in and format state geo data for spatial maps
%
%  states = p__.readStateGeoData();
%
% See also: p__, p__.getStateData

% Read in existing state shape database
states = shaperead('usastatehi.shp','UseGeoCoords',false);
% "Move" (and rescale) Alaska
states(2) = rescaleStateBounds(states(2),-122,53,0.25);
% "Move" Hawaii
states(11) = rescaleStateBounds(states(11),-127,35,1);

% Make sure it is in alphabetical order by state name
[~,index] = sortrows({states.Name}.','ascend'); 
states = states(index); 

   function state = rescaleStateBounds(state,xNew,yNew,scl)
      %RESCALESTATBOUNDS Helper function to rescale bounds on "outliers"
      %
      %  state = rescaleStateBounds(state,xNew,yNew,scl);
      
      state.X = (state.X - state.X(1)) * scl + xNew;
      state.Y = (state.Y - state.Y(1)) * scl + yNew;
      bX = state.BoundingBox(3)-state.BoundingBox(1);
      bY = state.BoundingBox(4)-state.BoundingBox(2);
      state.BoundingBox = [xNew, yNew, xNew+bX*scl, yNew+bY*scl];
      state.LabelLat = yNew+0.5;
      state.LabelLon = xNew+0.5;
   end

end