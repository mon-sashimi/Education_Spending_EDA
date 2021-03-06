function schema
%SCHEMA Define the Visible class

%   Copyright 1996-2003 The MathWorks, Inc.

pkg = findpackage('LayerEvent');
cEventData = findclass(findpackage('handle'),'EventData');
c = schema.class(pkg,'Visible',cEventData);

p = schema.prop(c,'Name','MATLAB array');
p.AccessFlags.PrivateGet = 'on';
p.AccessFlags.PrivateSet = 'on';
p.AccessFlags.PublicGet  = 'on';
p.AccessFlags.PublicSet  = 'off';

p = schema.prop(c,'Value','MATLAB array');
p.AccessFlags.PrivateGet = 'on';
p.AccessFlags.PrivateSet = 'on';
p.AccessFlags.PublicGet  = 'on';


