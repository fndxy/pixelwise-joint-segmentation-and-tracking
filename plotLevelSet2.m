function plotLevelSet2(u,zLevel,uv, style)

% draw the 0 level set in the narrowband
for i=1:size(uv,1)
   if(   u(uv(i,2),uv(i,1))   ==0)
       scatter(uv(i,1),uv(i,2));
   end
       
end


% [c,h] = contour(u,[zLevel zLevel],style); 
