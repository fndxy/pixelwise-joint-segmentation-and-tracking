function [Wfx, Wbx]=get_wfbx_JRACS(I,phi,x,y,WF,WB,...
    fore_hist,fore_hist_n,back_hist,back_hist_n,H,nBin,lamda)
% Function£∫calculate the wfi and wbi in the Eq.(14) and (15)
% Parameters:
%   I: current frame
%   phi: signed distance function
%   x,y: the coordination
%   WF,WB: see the Eq.(14) and Eq.(15)
%   fore_hist: foreground histogram of the target
%   fore_hist_n: foreground histogram of the target candidate
%   back_hist: background histogram of the target
%   back_hist_n: foreground histogram of the target region
%   H: heaviside valude of narrow band
%   nBin:
%   curMode:
%   lamda:
% Return:
%   Wfx;
%   Wbx:,
% **********************************************************************;

Wbx=zeros(size(x,1),1);
Wfx=zeros(size(x,1),1);
hist_level=256/nBin;
[max_row, max_col]=size(I);
num = size(x);
for i=1:num
    row=(x(i));
    col=(y(i));

    v=I(row,col,:);
    v = floor(v/hist_level)+1;
    index=(v(1)-1)*nBin*nBin+(v(2)-1)*nBin+v(3);   %RGBÕºœÒ≈≈¡– 
    
    Wfx(i)=sqrt(fore_hist(index)/(fore_hist_n(index)+eps));
    Wbx(i)=sqrt(back_hist(index)/(back_hist_n(index)+eps));
end

cof1=WF/WB;
Wfx=cof1*Wfx/WF;
Wbx=lamda*Wbx/WB;