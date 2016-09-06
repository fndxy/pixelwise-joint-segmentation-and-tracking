function Delta_h = Delta(phi,epsilon,x,y)
% Function£ºcalculate the derivation of Heaviside value
% Parameters:
%   phi: level set
%   epsilon:important parameter of Heaviside fuction   
%   x,y: coordination of narrow band
% Return:
%   Delta_h: the derivation of Heaviside function%    
% -------------------------------------------------------------------------

Delta_h=zeros(size(x));
num = size(x,1);
molecule  =(epsilon/pi); 
e2 = epsilon^2;

for i=1:num    
    Delta_h(i)=molecule./(e2+ phi(x(i),y(i))^2);
end