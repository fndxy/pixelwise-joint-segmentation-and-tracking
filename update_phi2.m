function [phi_new,uv_new]=update_phi2(phi,delta_p,uv,border)
% Function: updaing level set by using estimatd matrix delta_p
% Parameters:
%   phi: level set. the target contour is embedded into this level set
%   delta_p: affine matrix of the moved target
%   uv: the coordination of narrow band
%   border: 
% Return:
%   phi_new: updated phi
%   un_new: updated phi
% **************************************************************8

M = [delta_p; 0 0 1];
M(1,1) = M(1,1) + 1;
M(2,2) = M(2,2) + 1;

uv_new=uv;
uv_new=uv_new';
uv_new = [uv_new; ones(1,size(uv_new,2))];

% uv = M * xy;
uv_new = M * uv_new;
% Remove homogeneous
uv_new = uv_new(1:2,:)';
uv_new= round(uv_new);

phi_new=phi;

[max_x, max_y]=size(phi);
for i=1:size(uv,1)
    n1=uv(i,:);
    m1=uv_new(i,:);
    if (m1(2)>=1)&&(m1(2)<=max_x)&&(m1(1)>=1)&&(m1(1)<=max_y)
        phi_new(m1(2) ,m1(1)) =phi(n1(2),n1(1));
    end
end

[row,col] = find(phi_new<border & phi_new>-border);
uv_new=[col,row];