function dwdp_v=get_dwdp_v(x,y)
% get the dwdp (the equation is in the Lucus paper) of the narrowband
dwdp_v=zeros(2,6,size(x,1));
num = size(x);

for i=1:num
    dwdp_v(:,:,i)=get_dwdp(x(i),y(i));
end