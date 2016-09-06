function [Delta_h,s] = Delta2(phi,epsilon,x,y)
%使用矩阵形式

Delta_h=zeros(size(x));
num = size(x,1);
molecule  =(epsilon/pi);
e2 = epsilon^2;

for i=1:num
    Delta_h(i)=molecule./(e2+ phi(x(i),y(i))^2);
end
s=sum(Delta_h);
 
 
%  
%  Elapsed time is 0.000144 seconds.
% Elapsed time is 0.003464 seconds.
% tic
%  ind = sub2ind(size(phi),x,y);  %这个方法慢
%  Delta_h2=(epsilon/pi)./(epsilon^2+ phi(ind).^2);
%  toc