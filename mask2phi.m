% converts a mask to a SDF  
function phi = mask2phi(init_a)
phi=bwdist(init_a)-bwdist(1-init_a);
% +im2double(init_a)-0.5;
