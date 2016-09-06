function  BW= gettemplate(I)

% input : I- image
% output: BW- mask of the target
% output: fore_co- extremum of x and y of the foreground rectangle   
% output: back_co- extremum of x and y of the background rectangle
% output: template_pts- four coordinates of the background rectangle
% output: p_init- zeros(2, 3);
% output: fore_rec- four coordinates of the foreground rectangle


figure();imshow(I);hold on;
title('Please draw the expected object','FontSize',[10],'Color', 'r');
BW = roipoly;