
function uv=get_idx(p_init,template_pts)

M = [p_init; 0 0 1];
M(1,1) = M(1,1) + 1;
M(2,2) = M(2,2) + 1;
minv = min(template_pts');
maxv = max(template_pts');

% Get all points in destination to sample
[xg yg] = meshgrid(minv(1):maxv(1), minv(2):maxv(2));
uv = [reshape(xg, numel(xg), 1)'; reshape(yg, numel(yg), 1)'];
uv=uv';
