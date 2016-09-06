function H = Heaviside(phi,epsilon,x,y)
% Function: calculate heaviside value of narrow band
% Parameters:
%   phi:level set
%   epsilon: important parameter of Heaviside function
%   x,y:heaviside value of narrow band
% Return:
%   H: heaviside value of narrow band
%----------------------------------------------------------------------

num=size(x,1);
pii=(2/pi);
for i=1:num
    H(i) = 0.5*(1+ pii*atan(phi(x(i),y(i))./epsilon));
end
H=H';