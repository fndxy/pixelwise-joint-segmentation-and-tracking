function  dwdp =get_dwdp(x,y)
% get the dwdp (the equation is in the Lucus paper)
%  x,y����ѧ�����ʽ ��x�Ǵ�����
dwdp=[x 0 y 0 1 0;
      0 x 0 y 0 1];
