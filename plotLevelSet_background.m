function [c,h]=plotLevelSet_background(u,border, style)
%   plotLevelSet(u,zLevel, style) plot the level contour of function u at
%   the zLevel.
%   created on 04/26/2004
%   author: Chunming Li
%   email: li_chunming@hotmail.com
%   Copyright (c) 2004-2006 by Chunming Li
 [c,h] = contour(u,[-border-1, -border-1],'w'); 
 [c,h] = contour(u,[-border, -border],'r'); 
 [c,h] = contour(u,[-border+1, -border+1],'w'); 