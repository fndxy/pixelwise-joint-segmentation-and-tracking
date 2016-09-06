function J= get_J(Delta_h,gra,dwdp_v)    
% Function: calculate J (refer to Eq.(20) in the paper) 
% Parameters:
%    Delta_h:
%    gra:
%    dwdp_v:
% Return: J
% ******************************************
 J=zeros(size(Delta_h,1),6);
 num = size(Delta_h);
 for i=1:num
     J(i,:)=Delta_h(i)*(gra(i,:)*dwdp_v(:,:,i));
 end