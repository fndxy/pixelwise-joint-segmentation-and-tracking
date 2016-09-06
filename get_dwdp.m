function  dwdp =get_dwdp(x,y)
% get the dwdp (the equation is in the Lucus paper)
%  x,y以数学表达形式 即x是代表列
dwdp=[x 0 y 0 1 0;
      0 x 0 y 0 1];
