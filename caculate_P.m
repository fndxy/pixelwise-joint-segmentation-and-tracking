function [Pf,Pb] = caculate_P(I,fore_hist,back_hist,row,col,nBin)
%计算 Pf,Pb 
% I 图像
% fore_hist 前景直方图分布  back_hist背景直方图分布
% ind_x 纵向 ind_y横向
% nBin直方图分辨率

level = 256/nBin;
num = size(row,1);
for i = 1:num
    y = row(i);
    x = col(i);
    R = floor(I(y,x,1)/level)+1;
    G = floor(I(y,x,2)/level)+1;
    B = floor(I(y,x,3)/level)+1;
    index=(R-1)*nBin*nBin+(G-1)*nBin+B;
    Pf(i) = fore_hist(index);
    Pb(i) = back_hist(index);
end
